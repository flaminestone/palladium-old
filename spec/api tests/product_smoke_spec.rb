require_relative '../../api/api'
require 'json'
describe 'Unit tests' do
  before :all do
    @api = Api.new('localhost:3000', 'flamine@list.ru', 'NX_FY9zLz5BFH-qVvDHE')
    # Product Data
    @product_name = "Test Product_name#{Time.now.nsec}"
    @product_params = {:product => {:name => @product_name}}
    response_product = @api.add_new_product(@product_params)
    @product_id = JSON.parse(response_product)['id']
  end

  describe 'Products' do

    it 'add_new_product' do
      params = {:product => {:name => "add_new_product test#{Time.now.nsec}"}}
      response = @api.add_new_product(params)
      expect(JSON.parse(response)['name']).to eq params[:product][:name]
      expect(JSON.parse(response)['created_at']).not_to be_nil
    end

    it 'add_new_product with status field' do
      params = {:product => {:name => "add_new_product with status field test#{Time.now.nsec}", :status => "status#{Time.now.nsec}"}}
      response = @api.add_new_product(params)
      expect(JSON.parse(response)['name']).to eq params[:product][:name]
      expect(JSON.parse(response)['created_at']).not_to be_nil
      expect(JSON.parse(response)['updated_at']).not_to be_nil
    end

    it 'get_all_products' do
      response = JSON.parse @api.get_all_products
      expect(response).not_to be_empty
    end

    it 'get_products_by_param' do
      response = JSON.parse(@api.get_products_by_param({:name => @product_name}))
      expect(response.values.first['name']).to eq @product_name
      expect(response.values.first['created_at']).not_to be_nil
      expect(response.values.first['updated_at']).not_to be_nil
    end

    it 'edit_product' do
      response = @api.add_new_product(@product_params)
      id = JSON.parse(response)['id']
      params = {:product => {:name => "name_after_edit#{Time.now.nsec}",
                             :id => id}}
      response = @api.edit_product(params)
      response = JSON.parse(response)
      expect(response['name']).to eq(params[:product][:name])
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
end
