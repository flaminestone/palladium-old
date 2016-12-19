class RunsController < ApplicationController
  before_action :set_run, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User

  # GET /runs
  # GET /runs.json
  def index
    @runs = Product.find(product_find_by_id).plans.find(params.require(:plan_id)).runs
  end

  # GET /runs/1
  # GET /runs/1.json
  def show
  end

  # GET /runs/new
  # This method will be commented because creation can be only through API
  # def new
  #   @product = product_find_by_id
  #   @plan = plan_find_by_id
  #   @run = Run.new
  # end

  # GET /runs/1/edit
  def edit
    @product = product_find_by_id
    @plan = plan_find_by_id
    @run = set_run
  end

  # POST /runs
  # POST /runs.json
  def create
    @run = Run.new(run_params)
    plan_for_runs = Plan.find(params.require(:plan_id))
    respond_to do |format|
      if @run.save
        plan_for_runs.runs << @run
        # This string will be commented because creation can be only through API
        # format.html { redirect_to product_plan_run_path(product_find_by_id, plan_find_by_id, @run), notice: 'Run was successfully created.' }
        format.json { render :json => {@run.id => {'name' => @run.name,
                                                   'version' => @run.version,
                                                   'product_id' => @run.plan_id,
                                                   'created_at' => @run.created_at,
                                                   'updated_at' => @run.updated_at}} }
      else
        render :json => @run.errors
      end
    end
  end

  # PATCH/PUT /runs/1
  # PATCH/PUT /runs/1.json
  def update
    respond_to do |format|
      if @run.update(run_params)
        format.json { render json: @run }
        format.html { redirect_to action: 'show', id: set_run, notice: 'Run was successfully updated.' }
        format.json { render :show, status: :ok, location: @run }
      else
        format.html { render :edit }
        format.json { render json: @run.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /runs/1
  # DELETE /runs/1.json
  def destroy
    set_run.destroy
    respond_to do |format|
      format.html { redirect_to action: "index", notice: 'Run was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_run
    @run = Run.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def run_params
    params.require(:run).permit(:name, :version)
  end

  def product_find_by_id
    Product.find(params.require(:product_id))
  end

  def plan_find_by_id
    Product.find(product_find_by_id).plans.find(params.require(:plan_id))
  end

  public
  def get_all_runs
    runs_json = {}
    Run.all.each do |current_run|
      runs_json.merge!(current_run.id => {'name' => current_run.name,
                                          'version' => current_run.version,
                                          'plan_id' => current_run.plan_id,
                                          'created_at' => current_run.created_at,
                                          'updated_at' => current_run.updated_at})
    end
    render :json => runs_json
  end

  def get_runs_by_param
    runs_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    runs = Run.find_by(find_params)
    if runs.nil?
      render :json => {}
    else
      runs = [runs] until runs.is_a?(Array)
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

  def get_all_result_sets_by_run
    result_sets_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    result_sets = Run.find(find_params['id']).result_sets
    if result_sets.empty?
      render :json => {}
    else
      result_sets.map do |current_result_set|
        result_sets_json.merge!(current_result_set.id => {'name' => current_result_set.name,
                                                          'date' => current_result_set.date,
                                                          'version' => current_result_set.version,
                                                          'run_id' => current_result_set.run_id,
                                                          'created_at' => current_result_set.created_at,
                                                          'updated_at' => current_result_set.updated_at})
      end
      render :json => result_sets_json
    end
  end
end
