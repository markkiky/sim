# frozen_string_literal: true

class Party < ApplicationRecord
  belongs_to :user
  has_many :payments, dependent: :destroy
end
