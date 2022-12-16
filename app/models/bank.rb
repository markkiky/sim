# frozen_string_literal: true

class Bank < ApplicationRecord
  has_many :texts
  has_many :transaction_types
  has_many :payments
end
