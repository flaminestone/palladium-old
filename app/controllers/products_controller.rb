class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :destroy]
  acts_as_token_authentication_handler_for User

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    @product = Product.new
  end

  # GET /products/1
  # GET /products/1.json
  def show
    # TODO: ATTENTION!! Found n+1 request. Fixme, pls
    @status_data = {}
    status_hash = {}
    Status.pluck(:id, :color).each{|curret_status| status_hash.merge!( {curret_status.first => curret_status.last}) }
    plans_id = @product.plans.pluck(:id)
    plans_id.each do |plan_id|
      data = []
      ResultSet.where(:plan_id => plan_id).group(:status).count.each do |key, value|
        data << {'data' => [value], 'color' => status_hash[%r(\d).match(key)[0].to_i] }
      end
      @status_data.merge!(plan_id => data)
      end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @products = Product.all.order('name ASC')
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.json { render json: @product}
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(product_params)
        format.json { render json: @product}
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    if params.has_key?(:product)
      @product = Product.find(params[:product][:id])
    else
      @product = Product.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:image)
  end

  public
  def get_products
    products_json = {}
    Product.all.each do |current_product|
      products_json.merge!(current_product.id => {'name' => current_product.name,
                                                  'created_at' => current_product.created_at,
                                                  'updated_at' => current_product.updated_at})
    end
    render :json => products_json
  end

  def get_products_by_param
    products_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    products = Product.find_by(find_params)
    if products.nil?
      render :json => {}
    else
      products = [products] unless products.is_a?(Array)
      products.each do |current_product|
        products_json.merge!(current_product.id => {'name' => current_product.name,
                                                    'created_at' => current_product.created_at,
                                                    'updated_at' => current_product.updated_at})
      end
      render :json => products_json
    end
  end

  def get_all_plans_by_product
    plans_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    plans = Product.find_by(find_params).plans
    if plans.empty?
      render :json => {}
    else
      plans.each do |current_plan|
        p current_plan
        plans_json.merge!(current_plan.id => {'name' => current_plan.name,
                                              'created_at' => current_plan.created_at,
                                              'updated_at' => current_plan.updated_at})
      end
      render :json => plans_json
    end
  end
end
