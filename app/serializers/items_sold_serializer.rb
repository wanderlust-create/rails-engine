class ItemsSoldSerializer
  include JSONAPI::Serializer
  attributes :name

  attributes :count do |object|
    object.total_items_sold
  end
end
