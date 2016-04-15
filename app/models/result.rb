class Result < ActiveRecord::Base
  validates :author, presence: {message: I18n.t('result.errors.not_presence')}
  belongs_to :result_set
  belongs_to :status
  # after_commit :count_result_set_status

  private
  def count_result_set_status
    unless self.result_set_id.nil?
      unless self.status.nil?
        if ResultSet.exists?(:id => self.result_set_id)
          result_set = ResultSet.find(self.result_set_id)
          unless result_set.results.count == number_of_results_in_status(result_set)
            update_status(result_set)
          end
        end
      end
    end
  end

  def result_set_status_is_nil?
    ResultSet.find(self.result_set_id).status.nil?
  end

  def results_with_main_status
    count = ResultSet.find(self.result_set_id).results.where(status_id: Status.find_by_main_status(true).id).map { |current_element| current_element.id }
    {name: Status.find(self.status_id).name, count: count.to_s, data: [count.count], color: Status.find_by_main_status(true).color}
  end

  def number_of_results_in_status(result_set)
    numbere_of_results = 0
    unless result_set.status.nil?
      result_set.status.each do |current_status|
        numbere_of_results += current_status[:count].size
      end
    end
    numbere_of_results
  end

  def update_status(result_set)
    result_set_status = []
    result_set.results.each do |current_result|
      if status_exist(current_result, result_set_status)

        edit_hash = {}
        result_set_status.each do |current_hash|
          if current_hash[:name] == Status.find(current_result.status_id).name
            name = current_hash[:name]
            count = current_hash[:count]+ [current_result.id]
            data = count.size
            edit_hash = {name: name, count: count, data: data}
          end
        end
        result_set_status.delete_if { |current_hash| current_hash[:name] == edit_hash[:name] }
        result_set_status << edit_hash
      else
        result_set_status << {name: Status.find(current_result.status_id).name, count: [current_result.id], data: [1], color: Status.find(current_result.status_id).color}
      end
    end
    result_set.update(status: result_set_status)
  end

  def status_exist(current_result, result_set_status)
    all_statuses = result_set_status.map { |current_status_hash| current_status_hash[:name] }
    all_statuses.include? Status.find(current_result.status_id).name
  end
end
