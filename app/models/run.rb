class Run < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('run.errors.not_presence')}
  belongs_to :plan
  has_many :result_sets, dependent: :destroy
  serialize :status

  # after_commit :count_plan_status
  # after_create :count_plan_status_after_create

  def count_plan_status
    unless self.plan_id.nil?
      if Plan.exists?(self.plan_id)
        plan = Plan.find(self.plan_id)
        unless Plan.find(self.plan_id).runs.nil?
          update_plan_status(plan)
        end
      end
    end
  end

  def update_plan_status(plan)
    plan_status = []
    runs = plan.runs
    runs.each do |current_run|
      status_hash = current_run.status
      status_hash = [{name: Status.find_by_main_status(true).name, color: Status.find_by_main_status(true).color, count: [:id]}] if status_hash.nil?
      status_hash.each do |current_status_element|
        edit_hash = {}
        if status_exist(current_status_element, plan_status)
          plan_status.each do |status_hash|
            if status_hash[:name] == current_status_element[:name]
              name = status_hash[:name]
              data = status_hash[:data].first + current_status_element[:data].first
              edit_hash = {name: name, data: [data], color: current_status_element[:color]}
            end
            plan_status.delete_if { |current_hash| current_hash[:name] == edit_hash[:name] }
            plan_status << edit_hash unless edit_hash.empty?
          end
        else
          plan_status << current_status_element
        end
      end
    end
    plan.update(status: plan_status)
  end

  def status_exist(current_status_element, plan_status)
    all_statuses = plan_status.map { |current_status_hash| current_status_hash[:name] }
    all_statuses.include? current_status_element[:name]
  end

  def count_plan_status_after_create
    self.update(status: [{:name => Status.find_by_main_status(true).name, :count => [:id], :data => [1], :color => Status.find_by_main_status(true).color}])
  end
end
