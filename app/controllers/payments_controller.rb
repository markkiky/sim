# frozen_string_literal: true

class PaymentsController < ApplicationController
  def index
    @payment = Payment.new
    @payments = current_user.payments.where(@conditions).order(transaction_date: :desc).includes(:bank, :party)
  end

  def create; end

  def payment_params
    params.permit(
      :payment_type,
      :payment_id
    )
  end
end
