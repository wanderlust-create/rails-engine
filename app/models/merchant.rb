# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :invoices
  has_many :items
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices

  def self.search(search_params)
    where('name ILIKE ?', "%#{search_params[:name]}%").order(:name) if search_params[:name]
  end

  def self.top_merchants_by_revenue(number)
    joins(invoices: %i[invoice_items transactions])
    .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
    .group('merchants.id')
    .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue')
    .order('total_revenue DESC')
    .limit(number)
  end

  def self.top_merchants_by_revenue(number)
    joins(invoices: %i[invoice_items transactions])
    .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
    .group('merchants.id')
    .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue')
    .order('total_revenue DESC')
    .limit(number)
  end

  def one_merchant_revenue
    self.invoice_items.joins(:transactions)
    .where(transactions: { result: 'success' }, invoices: { status: 'shipped' })
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
