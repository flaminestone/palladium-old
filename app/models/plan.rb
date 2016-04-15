class Plan < ActiveRecord::Base
  validates :name, presence: {message: I18n.t('plan.errors.not_presence')}
  belongs_to :product
  has_many :runs, dependent: :destroy
  serialize :status
  # after_create :count_plan_status_after_create

  def count_plan_status_after_create
  self.update(status:[{:name=>Status.find_by_main_status(true).name, :count=>[:id], :data=>[1], :color=>Status.find_by_main_status(true).color}])
  end

end
