# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true
  has_many :items

  def self.search(search_params)
    where('name ILIKE ?', "%#{search_params[:name]}%").order(:name) if search_params[:name]
  end
end
