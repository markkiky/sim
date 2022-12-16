# frozen_string_literal: true

class Payment < ApplicationRecord
  enum payment_type: { In: 0, Out: 1 }
  belongs_to :party
  belongs_to :user
  belongs_to :bank
  has_many :transaction_joins
  has_many :transaction_types, through: :transaction_joins

  after_create_commit { broadcast_prepend_to 'payments' }
end
