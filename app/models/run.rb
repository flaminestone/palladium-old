class Run < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('run.errors.not_presence')}
  belongs_to :plan
  has_many :result_sets, dependent: :destroy
  serialize :status

  # return [Hash] {result_set_id => {:count => int, :id => int, :color => str, :name => str}, {}, {}}
  def self.get_run_status(run_id, status_names = nil)
    status_names = Status.get_statuses if status_names.nil?
    result = {}
    ResultSet.where(:run_id => run_id).pluck(:id, :status).each { |result_set| result.merge!("#{result_set.first}": {"id": result_set[1], "color": status_names[result_set[1]][:color], "name": status_names[result_set[1]][:name]}) }
    result
  end
end
