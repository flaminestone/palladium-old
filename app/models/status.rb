class Status < ActiveRecord::Base
  has_many :results
  validates :name, presence: {message: I18n.t('status.errors.not_presence')},
            uniqueness: {message: I18n.t('status.errors.not_uniqueness')}
  validates :color, length: {is: 7, message: I18n.t('status.errors.length_is_overlong')},
            presence: {message: I18n.t('status.errors.not_presence')}

  validates_each :color do |record, attr, value|
    if value.match('\A.') == '#'
      value[1..6].downcase.each_char do |current_char|
        unless '1234567890abcdef'.include? current_char
          record.errors.add(attr, I18n.t('status.errors.not_correct_data'))
        end
      end
    else
      record.errors.add(attr, value.match('\A.') == '#')
    end
  end
end