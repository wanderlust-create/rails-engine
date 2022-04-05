# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
end
