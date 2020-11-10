class ItemImage < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  mount_uploader :image, ItemImageUploader
  belongs_to :item
  belongs_to_active_hash :prefecture

  validates :image, presence: true
end
