class ResultSet < ActiveRecord::Base
  belongs_to :run
  has_many :results, dependent: :destroy
  serialize :status
  after_commit :count_run_status

  private
  def count_run_status
    p 'count_run_status'
    unless self.results.nil?
      unless self.status.nil?
        unless self.run_id.nil?
          run = Run.find(self.run_id)
          update_run_status(run)
        end
      end
    end
  end

  def update_run_status(run)
    run_status = []
    run.result_sets.each do |current_result_set|                         # начинаем перебирать все result set,
      result = current_result_set.results.order(created_at: :desc).first # и брать последний записанный результат
      edit_hash = {}
      status_id = get_status_id(result)
      result_id = get_result_id(result)
      if status_exist(status_id, run_status)                  # проверка того, что в run.status уже есть такой статус, и необходимо просто перезаписать этот элемент массива
        run_status.each do |current_hash|
          if current_hash[:name] == Status.find(status_id).name
            name = current_hash[:name]
            count = current_hash[:count] + [result_id]
            data = count.size
            edit_hash = {name: name, count: count, data: data, color: Status.find(status_id).color}
          end
        end
        run_status.delete_if { |current_hash| current_hash[:name] == edit_hash[:name] }
        run_status << edit_hash unless edit_hash.empty?
      else
        run_status << {name: Status.find(status_id).name, count: [:id], data: [1], color: Status.find(status_id).color}
      end
    end
    run.update(status: run_status)
  end

  def status_exist(status_id, run_status)
    all_statuses = run_status.map { |current_status_hash| current_status_hash[:name] }
    all_statuses.include? Status.find(status_id).name
  end

  def get_status_id(status)
    if status.nil?
      Status.find_by_main_status(true).id
    else
       status.status_id
    end
  end

    def get_result_id(result)
      if result.nil?
        :id
      else
        result.id
      end
    end
end
