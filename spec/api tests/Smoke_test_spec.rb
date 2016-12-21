require_relative '../../api/api'
require 'json'
describe 'Unit tests' do
  before :all do
    @api = Api.new('localhost:3000', 'flamine@list.ru', '6gVmTd6Xk79z-4TwibSu')

    # Product Data
    @product_name = "Product_name#{Time.now.nsec}"
    @product_version = "Product_version#{Time.now.nsec}"
    @product_params = {:product => {:name => @product_name,
                                    :version => @product_version}}
    response_product = @api.add_new_product(@product_params)
    @product_id = JSON.parse(response_product)['id']

    # Plan Data
    @plan_name = "Plan_name#{Time.now.nsec}"
    @plan_version = "Plan_version#{Time.now.nsec}"
    @plan_params = {:plan => {:name => @plan_name,
                              :version => @plan_version},
                    :product_id => @product_id}

    response_plan = @api.add_new_plan(@plan_params)
    @plan_id = JSON.parse(response_plan)['id']

    # Run Data
    @run_name = "Run_name#{Time.now.nsec}"
    @run_version = "Run_name#{Time.now.nsec}"
    @run_params = {:run => {:name => @run_name,
                            :version => @run_version},
                   :plan_id => @plan_id}
    response_run = @api.add_new_run(@run_params)
    @run_id = JSON.parse(response_run)['id']

    # Result Set Data
    @result_set_name = "name#{Time.now.nsec}"
    @result_set_version = "version#{Time.now.nsec}"
    @result_set_date = "date#{Time.now.nsec}"
    @result_set_param = {:result_set => {:name => @result_set_name,
                                         :version => @result_set_version,
                                         :date => @result_set_date},
                         :run_id => @run_id}
    response_result_set = @api.add_new_result_set(@result_set_param)
    @result_set_id = (JSON.parse response_result_set)['id']
    # Result Data
    @result_message = "message#{Time.now.nsec}"
    @result_author = "author#{Time.now.nsec}"
    @result_params = {:result => {:message => @result_message,
                                  :author => @result_author},
                      :result_set_id => @result_set_id}
    result_responce = @api.add_new_result(@result_params)
    @result_id = (JSON.parse result_responce)['id']
    # Status
    @status_name = "name#{Time.now.nsec}"
    @status_color = "#FF0000"
    @status_params = {:status => {:name => @status_name, :color => @status_color}}
    status_response = @api.add_new_status(@status_params)
    @status_id = (JSON.parse status_response)['id']

  end

  describe 'Products' do

    it 'add_new_product' do
      params = {:product => {:name => "name#{Time.now.nsec}", :version => "version#{Time.now.nsec}"}}
      response = @api.add_new_product(params)
      expect(JSON.parse(response)['name']).to eq params[:product][:name]
      expect(JSON.parse(response)['status']).to be_nil
      expect(JSON.parse(response)['version']).to eq params[:product][:version]
      expect(JSON.parse(response)['created_at']).not_to be_nil
    end

    it 'add_new_product with status field' do
      params = {:product => {:name => "name#{Time.now.nsec}", :status => "status#{Time.now.nsec}", :version => "version#{Time.now.nsec}"}}
      response = @api.add_new_product(params)
      expect(JSON.parse(response)['name']).to eq params[:product][:name]
      expect(JSON.parse(response)['status']).to be_nil
      expect(JSON.parse(response)['version']).to eq params[:product][:version]
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'get_all_products' do
      response = JSON.parse @api.get_all_products
      expect(response).not_to be_empty
    end

    it 'get_products_by_param' do
      response = JSON.parse(@api.get_products_by_param({:name => @product_name}))
      expect(response.values.first['version']).to eq(@product_version)
      expect(response.values.first['name']).to eq @product_name
      expect(response.values.first['status']).to be_nil
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'get_all_plans_by_product' do
      params = {:id => @product_id}
      response = JSON.parse @api.get_all_plans_by_product(params)
      expect(response.keys.first).to eq(@plan_id.to_s)
    end

    it 'edit_product' do
      response = @api.add_new_product(@product_params)
      id = JSON.parse(response)['id']
      params = {:product => {:name => "name_after_edit#{Time.now.nsec}",
                             :status => response['status'],
                             :version => response['version']},
                :id => id}
      response = @api.edit_product(params)
      response = JSON.parse(response)
      expect(response['name']).to eq(params[:product][:name])
      expect(response['status']).to be_nil
      expect(response['version']).to eq(params[:product][:version])
      expect(response['created_at']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end

    it 'delete_product' do
      response = JSON.parse(@api.get_all_products)
      current_product_data = response[response.keys.first]
      params = {:id => response.keys.first}
      @api.delete_product(params)
      response = JSON.parse(@api.get_products_by_param({:name => current_product_data['ProductName']}))
      expect(response).to be_empty
    end
  end

  describe 'Plans' do

    it 'add_new_plan' do
      params = {:plan => {:name => "name#{Time.now.nsec}", :version => "version#{Time.now.nsec}"}, :product_id => @product_id}
      response = @api.add_new_plan(params)
      response = JSON.parse(response)
      expect(response['name']).to eq params[:plan][:name]
      expect(response['version']).to eq params[:plan][:version]
      expect(response['status']).to be_nil
      expect(response['product_id']).not_to be_nil
      expect(response['created_at']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end

    it 'get_all_plans' do
      response = JSON.parse @api.get_all_plans
      expect(response).not_to be_empty
    end

    it 'get_all_runs_by_plan' do
      params = {:id => @plan_id}
      response = JSON.parse @api.get_all_runs_by_plan params
      expect(response).not_to be_empty
    end

    it 'get_plans_by_param' do
      response = JSON.parse(@api.get_plans_by_param({:name => @plan_name}))
      expect(response.values.first['version']).to eq(@plan_version)
      expect(response.values.first['name']).to eq(@plan_name)
      expect(response.values.first['status']).to be_nil
      expect(response.values.first['product_id']).not_to be_nil
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'edit_plan' do
      response = JSON.parse @api.get_plans_by_param({:name => @plan_name})
      current_plan_data = response[response.keys.first]
      params = {:plan => {:name => "name_after_edit#{Time.now.nsec}",
                          :version => current_plan_data['version']}}
      params.merge!({:id => response.keys.first})
      response = @api.edit_plan(params)
      response = JSON.parse(response)
      expect(response['name']).to eq(params[:plan][:name])
      expect(response['version']).to eq(params[:plan][:version])
      expect(response['product_id']).not_to be_nil
      expect(response['created_at']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end

    it 'delete_plan' do
      response = JSON.parse(@api.get_all_plans)
      current_plan_data = response[response.keys.first]
      params = {id: response.keys.first}
      @api.delete_plan(params)
      response = JSON.parse(@api.get_plans_by_param({:name => current_plan_data['PlanName']}))
      expect(response).to be_empty
    end
  end

  describe 'Runs' do
    it 'get_all_runs' do
      response = JSON.parse @api.get_all_runs
      expect(response).not_to be_empty
    end

    it 'get_runs_by_param' do
      response = JSON.parse(@api.get_runs_by_param({:name => @run_name}))
      expect(response.values.first['version']).to eq(@run_version)
      expect(response.values.first['name']).to eq(@run_name)
      expect(response.values.first['plan_id']).not_to be_nil
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'get_all_result_sets_by_run' do
      params = {:id => @run_id}
      response = JSON.parse @api.get_all_result_sets_by_run params
      expect(response).not_to be_empty
    end

    it 'add_new_run' do
      params = {:run => {:name => "name#{Time.now.nsec}", :version => "version#{Time.now.nsec}"}, :plan_id => @plan_id}
      response = @api.add_new_run(params)
      expect(JSON.parse(response)['name']).to eq params[:run][:name]
      expect(JSON.parse(response)['version']).to eq params[:run][:version]
      expect(JSON.parse(response)['plan_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'edit_run' do
      response = JSON.parse @api.get_runs_by_param({:name => @run_name})
      current_plan_data = response[response.keys.first]
      params = {:run => {:name => "name_after_edit#{Time.now.nsec}",
                         :version => current_plan_data['version']},
                :id => response.keys.first}
      response = @api.edit_run(params)
      response = JSON.parse(response)
      expect(response['name']).to eq(params[:run][:name])
      expect(response['version']).to eq(params[:run][:version])
      expect(response['plan_id']).not_to be_nil
      expect(response['created_at']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end

    it 'delete_run' do
      run_params = {:run => {:name => "name#{Time.now.nsec}", :version => "version#{Time.now.nsec}"}, :plan_id => @plan_id}
      response = @api.add_new_run(run_params)
      params = {id: (JSON.parse response)['id']}
      @api.delete_run(params)
      response = JSON.parse(@api.get_runs_by_param({:name => run_params[:run][:name]}))
      expect(response).to be_empty
    end
  end

  describe 'Result Set' do
    it 'get_all_result_sets' do
      response = JSON.parse @api.get_all_result_sets
      expect(response).not_to be_empty
    end

    it 'add_new_result_set' do
      params = {:result_set => {:name => "name#{Time.now.nsec}",
                                :version => "version#{Time.now.nsec}",
                                :date => "date#{Time.now.nsec}"},
                :run_id => @run_id}
      response = @api.add_new_result_set(params)
      expect(JSON.parse(response)['name']).to eq params[:result_set][:name]
      expect(JSON.parse(response)['version']).to eq params[:result_set][:version]
      expect(JSON.parse(response)['run_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'add_new_result_set with status' do
      params = {:result_set => {:name => "name#{Time.now.nsec}",
                                :version => "version#{Time.now.nsec}",
                                :status => "status#{Time.now.nsec}",
                                :date => "date#{Time.now.nsec}"},
                :run_id => @run_id}
      response = @api.add_new_result_set(params)
      expect(JSON.parse(response)['name']).to eq params[:result_set][:name]
      expect(JSON.parse(response)['version']).to eq params[:result_set][:version]
      expect(JSON.parse(response)['status']).to be_nil
      expect(JSON.parse(response)['run_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'get_result_set_by_param' do
      response = JSON.parse(@api.get_result_set_by_param({:name => @result_set_name}))
      expect(response.values.first['version']).to eq(@result_set_version)
      expect(response.values.first['name']).to eq(@result_set_name)
      expect(response.values.first['run_id']).not_to be_nil
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'edit_result_set' do
      params_to_new_result_set = {:result_set => {:name => "name#{Time.now.nsec}",
                                                  :version => "version#{Time.now.nsec}",
                                                  :date => "date#{Time.now.nsec}"},
                                  :run_id => @run_id}
      response_new_result_set = @api.add_new_result_set(params_to_new_result_set)
      response_new_result_set = JSON.parse(response_new_result_set)
      params = {:result_set => {:name => "name_after_edit#{Time.now.nsec}",
                                :version => response_new_result_set['version'],
                                :date => response_new_result_set['date']},
                :id => response_new_result_set['id']}
      response = @api.edit_result_set(params)
      expect(JSON.parse(response)['name']).to eq params[:result_set][:name]
      expect(JSON.parse(response)['version']).to eq params[:result_set][:version]
      expect(JSON.parse(response)['run_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'edit_result_set with status' do
      params_to_new_result_set = {:result_set => {:name => "name#{Time.now.nsec}",
                                                  :version => "version#{Time.now.nsec}",
                                                  :date => "date#{Time.now.nsec}"},
                                  :run_id => @run_id}
      response_new_result_set = @api.add_new_result_set(params_to_new_result_set)
      response_new_result_set = JSON.parse(response_new_result_set)
      params = {:result_set => {:name => "name_after_edit#{Time.now.nsec}",
                                :version => response_new_result_set['version'],
                                :status => "status#{Time.now.nsec}",
                                :date => response_new_result_set['date']},
                :id => response_new_result_set['id']}
      response = @api.edit_result_set(params)
      expect(JSON.parse(response)['name']).to eq params[:result_set][:name]
      expect(JSON.parse(response)['version']).to eq params[:result_set][:version]
      expect(JSON.parse(response)['status']).to be_nil
      expect(JSON.parse(response)['run_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'delete_result_set' do
      params = {:result_set => {:name => "name#{Time.now.nsec}",
                                :version => "version#{Time.now.nsec}",
                                :date => "date#{Time.now.nsec}"},
                :run_id => @run_id}
      response = @api.add_new_result_set(params)
      params = {id: (JSON.parse response)['id']}
      @api.delete_result_set(params)
      response = @api.get_result_sets_by_param({:name => (JSON.parse response)['id']})
      expect(JSON.parse response).to be_empty
    end
  end

  describe 'Result' do
    it 'get_all_results' do
      response = JSON.parse @api.get_all_results
      expect(response).not_to be_empty
    end

    it 'get_result_by_param' do
      response = JSON.parse(@api.get_result_by_param({:author => @result_author}))
      expect(response).not_to be_empty
    end

    it 'add_new_result' do
      params = {:result => {:message => "message#{Time.now.nsec}",
                            :author => "author#{Time.now.nsec}"},
                :result_set_id => @result_set_id}

      response = @api.add_new_result(params)
      expect(JSON.parse(response)['message']).to eq params[:result][:message]
      expect(JSON.parse(response)['author']).to eq params[:result][:author]
      expect(JSON.parse(response)['result_set_id']).to eq(@result_set_id)
      expect(JSON.parse(response)['status_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'edit_result' do
      params = {:result => {:message => "message_after_edit#{Time.now.nsec}",
                            :author => @result_author},
                :id => @result_id}
      response = @api.edit_result(params)
      expect(JSON.parse(response)['message']).to eq params[:result][:message]
      expect(JSON.parse(response)['author']).to eq params[:result][:author]
      expect(JSON.parse(response)['result_set_id']).to eq(@result_set_id)
      expect(JSON.parse(response)['status_id']).not_to be_nil
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'delete_result' do
      params_result_for_create = {:result => {:message => "message#{Time.now.nsec}",
                                              :author => "author#{Time.now.nsec}"},
                                  :result_set_id => @result_set_id}
      response_result_for_create = @api.add_new_result(params_result_for_create)
      result_id = (JSON.parse response_result_for_create)['id']
      params = {:id => result_id}
      @api.delete_result(params)
      response = JSON.parse(@api.get_result_by_param({:author => params_result_for_create[:result][:author]}))
      expect(response).to be_empty
    end
  end

  describe 'Status' do
    it 'get_all_statuses' do
      response = JSON.parse @api.get_all_statuses
      expect(response).not_to be_empty
    end

    it 'get_statuses_by_param' do
      response = JSON.parse(@api.get_statuses_by_param({:name => @status_name}))
      expect(response.values.first['name']).to eq(@status_name)
      expect(response.values.first['color']).to eq @status_color
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'add_new_status' do
      params = {:status => {:name => "name#{Time.now.nsec}", :color => "#FF0000"}}
      response = @api.add_new_status(params)
      expect(JSON.parse(response)['name']).to eq params[:status][:name]
      expect(JSON.parse(response)['color']).to eq params[:status][:color]
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'edit_status' do
      response = JSON.parse @api.get_statuses_by_param({:name => @status_name})
      current_status_data = response[response.keys.first]

      params = {:status => {:name => "name_after_edit#{Time.now.nsec}",
                            :color => current_status_data['color']}}
      params.merge!({:id => response.keys.first})
      response = @api.edit_status(params)
      response = JSON.parse(response)
      expect(response['name']).to eq(params[:status][:name])
      expect(response['color']).to eq(current_status_data['color'])
      expect(response['created_at']).not_to be_nil
      expect(response['updated_at']).not_to be_nil
    end

    it 'delete_status' do
      params_status_for_create = {:status => {:name => "name#{Time.now.nsec}",
                                              :color => "#FF0000"}}
      response_status_for_create = @api.add_new_status(params_status_for_create)
      result_id = (JSON.parse response_status_for_create)['id']
      params = {:id => result_id}
      @api.delete_status(params)
      response = JSON.parse(@api.get_statuses_by_param({:name => params_status_for_create[:status][:name]}))
      expect(response).to be_empty
    end
  end
end
