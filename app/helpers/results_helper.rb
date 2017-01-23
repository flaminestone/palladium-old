module ResultsHelper
  def get_all_result_sets(plan_ids, result_set_name)
    results = []
    ResultSet.where(plan_id: plan_ids).where(name: result_set_name).order('updated_at ASC').pluck(:id, :status, :updated_at).each do |current_result|
      results << {:id => current_result[0],
                  :status_id => current_result[1],
                  :updated_at => current_result[2].strftime("%Y-%m-%d|%H:%M")}
    end
    results
  end
end
