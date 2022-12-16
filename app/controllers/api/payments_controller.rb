class Api::PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authorize_request

  # POST /api/payments
  def create
    params[:payments].each do |payment_hash|
      payment = OpenStruct.new(payment_hash)
      amount = payment.amount.remove(',')
      transaction_cost = payment.transaction_cost.remove(',')

      @bank = Bank.find_or_initialize_by(name: payment.bank)
      @bank.save unless @bank.id

      @transaction_type = @bank.transaction_types.find_or_initialize_by(name: payment.transaction_type)
      @transaction_type.save unless @transaction_type.id
      @party = current_user.parties.find_or_initialize_by(name: payment.party_name,
                                                          account_no: payment.party_account)
      @party.save unless @party.id
      @payment = current_user.payments.find_by(payment_id: payment.payment_id)

      payment_type = case payment.type
                     when 'In'
                       0
                     else
                       1
                     end
      @payment ||= Payment.create!(
        user_id: current_user.id,
        payment_type:,
        payment_id: payment.payment_id,
        bank_id: @bank.id,
        party_id: @party.id,
        amount:,
        transaction_cost:,
        transaction_date: Date.strptime(payment.transaction_date, '%d/%m/%y')
      )
    end

    render json: {
      message: 'Payments Received'
    }
  end

  # GET /api/payments
  def index
    @conditions = {}
    @conditions[:type] = params[:type] if params[:type].present?

    @pagy, @records = pagy(current_user.payments.where(@conditions))
    render json: {
      row_count: @pagy.in,
      page_size: @pagy.items,
      total_data_count: @pagy.count,
      page_count: @pagy.pages,
      current_page: @pagy.page,
      data: @records
    }
  end

  private

  def payment_params
    params.permit(
      :type,
      :bank,
      :payment_id,
      :party_name,
      :party_account,
      :amount,
      :transaction_cost,
      :transaction_type
    )
  end
end
