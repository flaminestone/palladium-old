class ResultsController < ApplicationController
  # before_action :set_result, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User
  include ResultsHelper
  # GET /results
  # GET /results.json
  def index
    @result_set = ResultSet.find_by_id(params.require(:result_set_id))
    @run = Run.find(@result_set.run_id)
    @plan = Plan.find(@run.plan_id)
    @product = Product.find(@plan.product_id)
    @results = ResultSet.compous_data(@result_set)
    @custom_fields = CustomField.get_like_json
    @statuses = Status.get_statuses
  end

  def history
    @result_set = ResultSet.find_by_id(params.require(:id))
    @run = Run.find(@result_set.run_id)
    @plan = Plan.find(@run.plan_id)
    @product = Product.find(@plan.product_id)
    # @results = get_all_result_sets(@product.plans.pluck(:id), @result_set.name)
    # @custom_fields = CustomField.get_like_json
    # @statuses = Status.get_statuses
  end

  # GET /results/1
  # GET /results/1.json
  def show
  end

  # GET /results/new
  def new
    @result = Result.new
    @product = product_find_by_id
    @plan = set_plan
    @run = set_run
  end

  # GET /results/1/edit
  def edit
    @product = product_find_by_id
    @plan = set_plan
    @run = set_run
    @result_set = set_result_set
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)
    # @result.plan_id = params[:plan_id]
    respond_to do |format|
      status_is_active?(params['status_id']) unless params['status_id'].nil?
      if @result.errors.empty?
        if @result.save && @result.errors.empty?
          if params['status_id'].nil?
            Status.find_by_main_status(true).results << @result
          else
            Status.find_by_id(params['status_id']).results << @result
          end
          set_result_set
          @result_set.results << @result
          @result_set.update!(status: @result.status_id)
          # format.html { redirect_to product_plan_run_result_set_result_path(product_find_by_id, set_plan, set_run, set_result_set, @result), notice: 'Result was successfully created.' }
          # This method will be commented because creation can be only through API
          format.json { render :json => @result }
        else
          format.html { render :new }
          format.json { render json: @result.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def status_is_active?(status_id)
    @result.errors.add(:status, 'Status is disable') if Status.find(status_id).disabled
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
    respond_to do |format|
      if @result.update(result_params)
        # format.html { redirect_to product_plan_run_result_set_result_path(product_find_by_id, set_plan, set_run, set_result_set, @result), notice: 'Result was successfully updated.' }
        # This method will be commented because creation can be only through API
        format.json { render :json => @result }
      else
        format.html { render :edit }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result.destroy
    respond_to do |format|
      # format.html { redirect_to action: "index", notice: 'Result was successfully destroyed.' }
      # This method will be commented because creation can be only through API
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_result
    @result = Result.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_params
    params.require(:result).permit(:message, :author, :result_set_id, :status_id, :plan_id)
  end

  def set_run
    @run = Run.find_by_run_id(params[:run_id])
  end

  def set_plan
    @plan = Plan.find_by_plan_id(params[:plan_id])
  end

  def product_find_by_id
    Product.find_by_id(params.require(:product_id))
  end

  def set_result_set
    @result_set = ResultSet.find_by_id(params[:result_set_id])
  end

  public
  def get_all_results
    results_json = {}
    Result.all.each do |current_result|
      results_json.merge!(current_result.id => {'message' => current_result.message,
                                                'author' => current_result.author,
                                                'result_set_id' => current_result.result_set_id,
                                                'status_id' => current_result.status_id,
                                                'created_at' => current_result.created_at,
                                                'updated_at' => current_result.updated_at})
    end
    render :json => results_json
  end

  def get_result_by_param
    results_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    results = Result.find_by(find_params)
    if results.empty?
      render :json => {}
    else
      results = [results] until results.is_a?(Array)
      results.each do |current_result|
        results_json.merge!(current_result.id => {'message' => current_result.message,
                                                  'author' => current_result.author,
                                                  'result_set_id' => current_result.result_set_id,
                                                  'status_id' => current_result.status_id,
                                                  'created_at' => current_result.created_at,
                                                  'updated_at' => current_result.updated_at})
      end
      render :json => results_json
    end
  end
end
