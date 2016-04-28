class Run < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('run.errors.not_presence')}
  belongs_to :plan
  has_many :result_sets, dependent: :destroy
  serialize :status
end
