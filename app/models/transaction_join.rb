# frozen_string_literal: true

class TransactionJoin < ApplicationRecord
  belongs_to :payment
  belongs_to :transaction_type
end
