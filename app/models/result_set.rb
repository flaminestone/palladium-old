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

  def self.compous_data(result_set)
    results = []
    result_set.results.pluck(:id, :message, :author, :status_id, :created_at).reverse.each do |current_result|
      message = self.try_to_reformat_message(current_result[1])
      results << {:id => current_result[0],
                 :message => message,
                 :author => current_result[2],
                 :status_id => current_result[3],
                 :created_at => current_result[4].strftime("%Y-%m-%d|%H:%M")}
    end
    results
  end

  def self.try_to_reformat_message(message)
    return {} if message.empty? || message.nil?
    begin
      result = JSON.parse(message)
    rescue
      {'message': message}
    end
  end
end

