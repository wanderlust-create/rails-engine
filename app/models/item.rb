# frozen_string_literal: true

class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  validates :merchant_id, presence: true, numericality: true

  belongs_to :merchant

  def self.search(search_params)
    if search_params[:name]
      where('name ILIKE ?', "%#{search_params[:name]}%").order(:name).limit 1

    elsif search_params[:min_price]
      where('unit_price >= ?', search_params[:min_price].to_f).order(:name).limit 1

    elsif search_params[:max_price]
      where('unit_price <= ?', search_params[:max_price].to_f).order(:name).limit 1

    else
      search_params[:min_price] && search_params[:max_price]
      where('unit_price > ?  and unit_price < ?', search_params[:min_price]).order(:unit_price).limit 1
    end
  end
end
