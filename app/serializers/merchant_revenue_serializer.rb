class MerchantRevenueSerializer
  include JSONAPI::Serializer

  attributes :revenue do |object|
    object.one_merchant_revenue
  end
end
