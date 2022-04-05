# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :invoice
  has_many :invoice_items, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  scope :successful, -> { where(result: 'sucessful') }
end
