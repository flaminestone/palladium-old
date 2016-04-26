class Result < ActiveRecord::Base
  validates :author, presence: {message: I18n.t('result.errors.not_presence')}
  belongs_to :result_set
  belongs_to :status
end
