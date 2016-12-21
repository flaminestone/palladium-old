class Product < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('product.errors.not_presence')}
  has_many :plans, dependent: :destroy
  has_attached_file :image, styles: {medium: "300x300>", thumb: "100x100>"}, default_url: "missing.gif"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
