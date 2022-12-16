# frozen_string_literal: true

class User < ApplicationRecord
  has_many :texts, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :parties, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
end
