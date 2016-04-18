class ResultsController < ApplicationController
  before_action :set_result, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User

  # GET /results
  # GET /results.json
  def index
    @result_set = ResultSet.find(params.require(:result_set_id))
    @results = @result_set.results
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
    @result_set = set_result_set
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
    @result.plan_id = params[:plan_id]
    set_result = set_result_set
    respond_to do |format|
      status_is_active?(params['status_id']) unless params['status_id'].nil?
      if @result.errors.empty?
        if @result.save && @result.errors.empty?
          if params['status_id'].nil?
            Status.find_by_main_status(true).results << @result
          else
            Status.find(params['status_id']).results << @result
          end
          set_result.results << @result
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
    @result = Result.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_params
    params.require(:result).permit(:message, :author)
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

  def set_result_set
    @result_set = ResultSet.find(params[:result_set_id])
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
