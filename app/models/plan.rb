class Plan < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('plan.errors.not_presence')}
  belongs_to :product
  has_many :runs, dependent: :destroy
  serialize :status
end
