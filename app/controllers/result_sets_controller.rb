class ResultSetsController < ApplicationController
  before_action :init_all_resourses, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User


  # GET /result_sets
  # GET /result_sets.json
  def index
    @run = set_run
    @result_sets = @run.result_sets
  end

  # GET /result_sets/1
  # GET /result_sets/1.json
  def show
    @results = Result.where(result_set_id: ResultSet.where(run_id: Run.where(plan_id: @product.plans.ids).ids, name: @result_set.name).ids)
  end

  # GET /result_sets/new
  def new
    @result_set = ResultSet.new
  end

  # GET /result_sets/1/edit
  def edit
  end

  # POST /result_sets
  # POST /result_sets.json
  def create
    @result_set = ResultSet.new(result_set_params)
    run = set_run
    respond_to do |format|
      if @result_set.save
        run.result_sets << @result_set
        # format.html { redirect_to product_plan_run_result_set_path(product_find_by_id, set_plan, set_run, @result_set), notice: 'Result set was successfully created.' }
        # This string will be commented because creation can be only through API
        format.json { render :json => {@result_set.id => {'name'=> @result_set.name,
                                                   'version' => @result_set.version,
                                                   'date' => @result_set.date,
                                                   'product_id'=> @result_set.run_id,
                                                   'created_at'=> @result_set.created_at,
                                                   'updated_at'=> @result_set.updated_at}} }
      else
        format.html { render :new }
        format.json { render json: @result_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /result_sets/1
  # PATCH/PUT /result_sets/1.json
  def update
    init_all_resourses
    respond_to do |format|
      if @result_sets.update_all(result_set_params)
        format.html { redirect_to result_set_url(@result_set), notice: 'Result set was successfully updated.' }
        # This string will be commented because creation can be only through API
        format.json { render :json => @result_set }
      else
        format.html { render :edit }
        format.json { render json: @result_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /result_sets/1
  # DELETE /result_sets/1.json
  def destroy
    init_all_resourses
    @result_sets.destroy_all
    respond_to do |format|
      format.html { redirect_to run_result_sets_path(@run), notice: 'Result set was successfully destroyed.' }
      # This method will be commented because creation can be only through API
      format.json { head :no_content }
    end
  end

  private

  def init_all_resourses
    @result_set = set_result_set
    @run = Run.find(@result_set.run_id)
    @plan = Plan.find(@run.plan_id)
    @product = Product.find(@plan.product_id)
    @result_sets = ResultSet.where(run_id: Run.where(plan_id: Product.find(@product).plans.ids).ids, name: set_result_set.name)
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_result_set
    @result_set = ResultSet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_set_params
    params.require(:result_set).permit(:name, :date, :version)
  end

  def set_run
    @run = Run.find(params[:run_id])
  end

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def product_find_by_id
    Product.find(params.require(:product_id))
  end

  public
  def get_all_result_sets
    result_sets_json = {}
    ResultSet.all.each do |current_result_set|
      result_sets_json.merge!(current_result_set.id => {'name' => current_result_set.name,
                                                        'date' => current_result_set.date,
                                                        'version' => current_result_set.version,
                                                        'run_id' => current_result_set.run_id,
                                                        'created_at' => current_result_set.created_at,
                                                        'updated_at' => current_result_set.updated_at})
    end
    render :json => result_sets_json
  end

  def get_result_sets_by_param
    result_sets_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    result = ResultSet.find_by(find_params)
    if result.nil?
      render :json => {}
    else
      result = [result] until result.is_a?(Array)
      result.each do |current_result|
        result_sets_json.merge!(current_result.id => {'name' => current_result.name,
                                                      'date' => current_result.date,
                                                      'version' => current_result.version,
                                                      'status' => current_result.status,
                                                      'run_id' => current_result.run_id,
                                                      'created_at' => current_result.created_at,
                                                      'updated_at' => current_result.updated_at})
      end
      render :json => result_sets_json
    end
  end
end