class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
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
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :version)
  end

  public
  def get_products
    products_json = {}
    Product.all.each do |current_product|
      products_json.merge!(current_product.id => {'ProductName' => current_product.name,
                                                  'ProductStatus' => current_product.status,
                                                  'ProductVersion' => current_product.version,
                                                  'CreatedAt' => current_product.created_at,
                                                  'UpdatedAt' => current_product.updated_at})
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
        products_json.merge!(current_product.id => {'ProductName' => current_product.name,
                                                    'ProductStatus' => current_product.status,
                                                    'ProductVersion' => current_product.version,
                                                    'CreatedAt' => current_product.created_at,
                                                    'UpdatedAt' => current_product.updated_at})
      end
      render :json => products_json
    end
  end

  def get_all_plans_by_product
    plans_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    plans = Product.find(find_params['id']).plans
    if plans.nil?
      render :json => {}
    else
      plans = [plans] unless plans.is_a?(Array)
      plans.each do |current_plan|
        plans_json.merge!(current_plan.first.id => {'PlanName' => current_plan.first.name,
                                                    'PlanVersion' => current_plan.first.version,
                                                    'CreatedAt' => current_plan.first.created_at,
                                                    'UpdatedAt' => current_plan.first.updated_at})
      end
      render :json => plans_json
    end
  end
end
