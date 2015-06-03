module Resource
module ResultSet
  # api/result_set/get_all_result_sets
  # @return [String] with all result_sets data. Use +JSON.parse string+ to convert it to hash
  def get_all_result_sets
    send_get_request('result_sets/get_all_result_sets', {:user_email => @username, :user_token => @token})
  end

  # api/result_set/get_result_set_by_param
  # @return [String] with result_set data. Use +JSON.parse string+ to convert it to hash
  def get_result_set_by_param(param)
    raise('Method result_set get hash with one pair keys and values') unless param.keys.size == 1
    param = {param.keys.first.to_s => param.values.first.to_s}
    send_get_request('result_sets/get_result_sets_by_param', {:user_email => @username, :user_token => @token, :param => param})
  end
  alias_method :get_result_sets_by_param, :get_result_set_by_param

  # api/result_set/add_new_result_set
  # @param params [Hash] with result_set data and product id.
  # @return [String] with established data
  # Example:
  # {:result_set => {:name => "ResultSetName",
  #                 :version => "ResultSetVersion",
  #                 :date => "ResultSetDate"},
  # :run_id => 'Run_Id'}
  # => "{"id":6126,"name":"name344658327","date":"date344683020","version":"version344671751","status":null,"run_id":2289,"created_at":"2015-06-03T12:49:18.356Z","updated_at":"2015-06-03T12:49:18.362Z"}"
  # You can change only ResultSetName, ResultSetData and ResultSetVersion (data type - string) and change run_id
  def add_new_result_set(params)
    params.merge!({:commit => 'Create Run'})
    response = send_post_request('result_sets/add_new_result_set', params)
    response.body
  end
end
end
