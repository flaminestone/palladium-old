class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User

  # GET /plans
  # GET /plans.json
  def index
    @plans = product_find_by_id.plans
    # @product_id = params.require(:product_id)
  end

  # GET /plans/1
  # GET /plans/1.json
  # For correctly working, need 2 varibles:
  # @param [Array] @main_data is a a double array [[run_id, run_name], [run_id, run_name], [run_id, run_name]].
  # data in @main_data must be sorted.
  # @param [Hash] @main_chart_data is a date for main chart on page. It have to be in specific format {status_id => {y => data_count, name => name_of_status, color => status_color}}
  def show
    @product = product_find_by_id
    return if ResultSet.where(:plan_id => params[:id]).empty?
    @main_data = Plan.get_plan_status(params[:id]).to_json
    @runs = Hash[*@plan.runs.pluck(:id, :name).flatten].to_json
    # @main_data must be like "{"21":{"3":{"count":96,"id":3,"color":"#FFFFAA","name":"Failed"},"12":{"count":2,"id":12,"color":"#FFFFAA","name":"9_st"}},"22":{"2":{"count":100,"id":2,"color":"#95d96d","name":"Passed"},"3":{"count":100,"id":3,"color":"#FFFFAA","name":"Failed"}}}"
    #"21" is a run id, 3 - status id, 96 - count of result_sets with this status, 3 - status id again, #FFFFAA - status color, Failed - status name
  end

  # GET /plans/1/edit
  def edit
    @product = product_find_by_id
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)
    product_for_plan = product_find_by_id
    respond_to do |format|
      if @plan.save
        product_for_plan.plans << @plan
        format.json { render :json => {@plan.id => {'name' => @plan.name,
                                                    'version' => @plan.version,
                                                    'status' => @plan.status,
                                                    'product_id' => @plan.product_id,
                                                    'created_at' => @plan.created_at,
                                                    'updated_at' => @plan.updated_at}} }
        format.html { redirect_to product_plan_url(product_find_by_id, @plan), notice: 'Plan was successfully created.' }
        format.json { render :show, status: :created, location: @plan }
      else
        format.html { render :new }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.json { render :json => @plan }
        format.html { redirect_to product_plan_path(product_find_by_id, @plan), notice: 'Plan was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan }
      else
        format.html { render :edit }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy
    respond_to do |format|
      format.html { redirect_to product_plans_path(product_find_by_id), notice: 'Plan was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:name, :version, :product_id)
  end

  def product_find_by_id
    Product.find(params.require(:product_id))
  end

  public
  def get_plans
    plans_json = {}
    Plan.all.each do |current_plan|
      plans_json.merge!(current_plan.id => {'name' => current_plan.name,
                                            'version' => current_plan.version,
                                            'product_id' => current_plan.product_id,
                                            'created_at' => current_plan.created_at,
                                            'updated_at' => current_plan.updated_at})
    end
    render :json => plans_json
  end

  def get_plans_by_param
    plans_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    plans = Plan.find_by(find_params)
    if plans.nil?
      render :json => {}
    else
      plans = [plans] until plans.is_a?(Array)
      plans.each do |current_plan|
        plans_json.merge!(current_plan.id => {'name' => current_plan.name,
                                              'version' => current_plan.version,
                                              'product_id' => current_plan.product_id,
                                              'created_at' => current_plan.created_at,
                                              'updated_at' => current_plan.updated_at})
      end
      render :json => plans_json
    end
  end

  def get_all_runs_by_plan
    runs_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    runs = Plan.find(find_params['id']).runs
    if runs.empty?
      render :json => {}
    else
      # runs = [runs] until runs.count == 1
      runs.each do |current_run|
        runs_json.merge!(current_run.id => {'name' => current_run.name,
                                            'version' => current_run.version,
                                            'plan_id' => current_run.plan_id,
                                            'created_at' => current_run.created_at,
                                            'updated_at' => current_run.updated_at})
      end
      render :json => runs_json
    end
  end
end
