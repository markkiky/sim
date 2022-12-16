# frozen_string_literal: true

module Api
  # API Controller for Chart Data
  class ChartsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorize_request
    before_action :set_payment_type, only: [:party_report]
    before_action :set_date_range, only: [:party_report]
    before_action :set_default_range, only: [:party_report]

    # GET /api/charts/party_report
    def party_report
      # Get Payments
      @payments = current_user.payments.where(@conditions)
      payments_sum = @payments.sum(:amount)

      # Get Payment parties
      party_ids = @payments.map { |payment| payment.party_id }
      @parties = Party.where(id: party_ids.uniq)

      # Build response
      response = []
      @parties.each do |party|
        party_payments = @payments.select { |payment| payment.party_id == party.id }
        party_sum = party_payments.sum(&:amount)

        response << {
          name: party.name,
          amount: party_sum.to_f.round(2),
          percentage: (party_sum / payments_sum * 100).to_f.round(2)
        }
      end

      render json: response.sort_by { |el| el[:percentage] }
    end

    # In/Out
    # Date Range
    def payment_report; end

    private

    def set_payment_type
      @conditions = {}
      payment_type = case params[:type]
                     when 'Out'
                       1
                     else
                       0
                     end

      @conditions[:payment_type] = payment_type
    end

    def set_date_range
      if params[:from].present? && params[:to].present?
        from = DateTime.parse(params[:from])
        to = DateTime.parse(params[:to])
        @conditions[:transaction_date] = from..to + 1
      elsif params[:from].present?
        from = DateTime.parse(params[:from])
        @conditions[:transaction_date] = from..DateTime.now
      elsif params[:to].present?
        created_at_to = DateTime.parse(params[:to])
        @conditions[:transaction_date] = to..DateTime.now
      end
    end

    def set_default_range
      @conditions.delete(:transaction_date)
      case params[:set_range]
      when 'Today'
        @conditions[:transaction_date] = Date.today...Date.today
      when 'This Month'
        @conditions[:transaction_date] = Date.today.beginning_of_month...Date.today.end_of_month
      when 'This Year'
        @conditions[:transaction_date] = Date.today.beginning_of_year...Date.today.end_of_year
      end
    end
  end
end
