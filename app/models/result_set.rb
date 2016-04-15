class ResultSet < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('result_set.errors.not_presence')}
  belongs_to :run
  has_many :results, dependent: :destroy
  serialize :status
end
