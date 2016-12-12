class Plan < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('plan.errors.not_presence')}
  belongs_to :product
  has_many :runs, dependent: :destroy
  serialize :status

  # return [Hash] {run_id => {:count => int, :id => int, :color => str, :name => str}, {}, {}}
  def self.get_plan_status(plan_id, status_names = nil)
    status_names = Status.get_statuses if status_names.nil?
    # get all resuls sets from plan with id = @param [Integer] plan_id
    result = {}
    ResultSet.where(:plan_id => plan_id).group_by(&:run_id).each  do |i|
      status_data = {}
      i[1].pluck(:status).uniq.map{ |uniq_id|
          status_data.merge!("#{uniq_id}": {'count': i[1].pluck(:status).count(uniq_id),
                              'id': uniq_id, 'color': status_names[uniq_id][:color],
                              'name': status_names[uniq_id][:name]})
      }
      result.merge!(i.first.to_s => status_data)
    end
    result
  end
end
