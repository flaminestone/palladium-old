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
  def show
    @product = product_find_by_id
    @status_names = {}
    @status_data = {} # for run charts
    results = ResultSet.where(:plan_id => params[:id])
    results_status_array = results.group(:status).count
    results_array = results.group(:run_id, :status).count
    Status.group(:id, :name, :color).order(id: :asc).count.keys.each { |current_status| @status_names.merge!({current_status[0] => {:name => current_status[1], :color => current_status[2]}}) }
    return if results_array.empty?
    runs_id_array = results_array.map { |current_element| {current_element[0][0] => {data: {:count => current_element[1], :color => current_element[0][1]}}} }
    runs_id_array.each do |plan_id|
      data = []
      all_data = 0
      data_sort = results_array.find_all { |curret_data| curret_data[0][0] == plan_id.keys.first }
      data_sort.each do |data_array|
        status_id = %r(\d).match(data_array[0][1])[0].to_i
        data << [status_id, {'data' => data_array[1], 'name' => @status_names[status_id][:name], 'color' => @status_names[status_id][:color]}]
        all_data += data_array[1]
      end
      temp = data.sort_by { |key| key }.to_h # need for sorting
      @status_data.merge!(plan_id.keys.first => {data: temp.values, all_data: all_data})
    end
    @main_chart_data = []
    results_status_array.each { |current|
      @main_chart_data << {:y => current[1], :name => @status_names[%r(\d).match(current[0])[0].to_i][:name], :color => @status_names[%r(\d).match(current[0])[0].to_i][:color]}
    }
    @main_chart_data
    @all_result_count = 0
    results_status_array.values.map { |i| @all_result_count += i }
  end

  # GET /plans/new
  # This method will be commented because creation can be only through API
  # def new
  #   @product = product_find_by_id
  #   @plan = Plan.new
  # end

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
