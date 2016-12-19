class ResultSet < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('result_set.errors.not_presence')}
  belongs_to :run
  has_many :results, dependent: :destroy
  serialize :status

  def self.add_multiplt_results(*args)
    status = Status.all
    result_sets = ResultSet.find(args.first[:id])
    result_sets.each do |current_result_set|
      result = Result.create(message: args.first[:comment], author: args.first[:author])
      current_result_set.results << result
      current_result_set.update!(status: args.first[:status].to_i)
      status.find(args.first[:status]).results << result
    end
  end
end
