require_relative '../../api/api'
require 'json'
describe 'Formation_status' do
  before :all do
    @api = Api.new('localhost:3000', 'flamine@list.ru', 'bBGm21gsxC2_zsNRY_Dw')
    # Add new Product
    product_params = {:product => {:name => "Product_name#{Time.now.nsec}",
                                   :version => "Product_version#{Time.now.nsec}"}}
    response_product = @api.add_new_product(product_params)
    @product_id = JSON.parse(response_product)['id']
    # Add new Plan
    plan_params = {:plan => {:name => "Plan_name#{Time.now.nsec}",
                             :version => "Plan_version#{Time.now.nsec}"},
                   :product_id => @product_id}
    response_plan = @api.add_new_plan(plan_params)
    @plan_id = JSON.parse(response_plan)['id']
    # Add new Run
    run_params = {:run => {:name => "Run_name#{Time.now.nsec}",
                           :version => "Run_version#{Time.now.nsec}"},
                  :plan_id => @plan_id}
    response_run = @api.add_new_run(run_params)
    @run_id = JSON.parse(response_run)['id']
    # Add new ResultSet
    result_set_param = {:result_set => {:name => "ResultSet_name#{Time.now.nsec}",
                                        :version => "ResultSet_version#{Time.now.nsec}",
                                        :date => "ResultSet_date#{Time.now.nsec}"},
                        :run_id => @run_id}
    response_result_set = @api.add_new_result_set(result_set_param)
    @result_set_id = (JSON.parse response_result_set)['id']

    @status_name = "Statusname#{Time.now.nsec}"
    @status_color = "#FF0000"
    @status_params = {:status => {:name => @status_name, :color => @status_color}}
    status_response = @api.add_new_status(@status_params)
    @status_id = (JSON.parse status_response)['id']

  end

  describe 'Without added status' do
    it 'create new result' do
      result_params = {:result => {:message => "Result_message#{Time.now.nsec}",
                                   :author => "Result_author#{Time.now.nsec}"},
                       :result_set_id => @result_set_id}
      result_responce = @api.add_new_result(result_params)
      @result_id = (JSON.parse result_responce)['id']
      result_set_status = @api.get_result_set_by_param(:id => @result_set_id)
      count = JSON.parse(result_set_status).values.first['status'].first['count']
      expect(count).to eq([@result_id].to_s)
    end

    it 'add results with different status' do
      result_params = {:result => {:message => "Result_message#{Time.now.nsec}",
                                   :author => "Result_author#{Time.now.nsec}"},
                       :result_set_id => @result_set_id}
      @api.add_new_result(result_params)
      result_params.merge!({:status_id => @status_id})
      result_responce = @api.add_new_result(result_params)
      @result_id = (JSON.parse result_responce)['id']
      result_set_status = @api.get_result_set_by_param(:id => @result_set_id)
      count = JSON.parse(result_set_status).values.first['status'].size
      expect(count).to eq(2)
    end
  end
end