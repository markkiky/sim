# frozen_string_literal: true

class TransactionType < ApplicationRecord
  belongs_to :bank
  has_many :transaction_joins
  has_many :payments, through: :transaction_joins
end
