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
    result_set.results.order('id ASC').pluck(:id, :message, :author, :status_id, :created_at).reverse.each do |current_result|
      message = self.try_to_reformat_message(current_result[1])
      results << {:id => current_result[0],
                 :message => message,
                 :author => current_result[2],
                 :status_id => current_result[3],
                 :created_at => current_result[4].strftime("%Y-%m-%d|%H:%M")}
    end
    results
  end

  # getting all result sets with one name and belongs to one product
  def self.get_data_by_name_for_all_time(result_set_name, product, count)
    results = []
    plans_t = []
    runs_t = []
    ResultSet.where(name: result_set_name).where(plan_id: product.plans.pluck(:id)).order('updated_at ASC').take(count).pluck(:id, :status, :updated_at, :run_id, :plan_id).reverse.each do |current_result|
      results << {:id => current_result[0],
                  :status_id => current_result[1],
                  :updated_at => current_result[2].strftime("%Y-%m-%d %H:%M"),
                  :run_id => current_result[3],
                  :plan_id => current_result[4]}
      runs_t <<  current_result[3]
      plans_t <<  current_result[4]
    end
    plans = {}
    Plan.where(id: plans_t).pluck(:id, :name).map{ |current_plan| plans.merge!({current_plan[0] => current_plan[1]})}
    runs = {}
    Run.where(id: runs_t).pluck(:id, :name).map{ |current_run| runs.merge!({current_run[0] => current_run[1]})}
    [results, plans, runs]
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

