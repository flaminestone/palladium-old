class ResultSetsController < ApplicationController
  # before_action :init_all_resourses, only: [:show, :edit, :update, :destroy]
  acts_as_token_authentication_handler_for User


  # GET /result_sets
  # GET /result_sets.json
  def index
    @run = set_run
    @result_sets = @run.result_sets
    @main_chart_data = []
    statuses_id_array = Status.pluck(:id, :name, :color)
    ResultSet.where(:run_id => params[:run_id]).group(:status).count.each do |key, value|
      statuses_id_array.each do |curren_status|
        if curren_status.first.to_s == %r(\d).match(key).to_s
          @main_chart_data << {name: curren_status[1], color: curren_status.last, y: value}
        end
      end
    end
    @statuses = Status.all
    @all_result_count = 0
    @main_chart_data.each {|el| @all_result_count += el[:y]}
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
    set_result_set
    @statuses = Status.all
  end

  # POST /result_sets
  # POST /result_sets.json
  def create
    attr = result_set_params.merge(params.permit(:run_id, :plan_id))
    @result_set = ResultSet.new(attr.merge({:status => params['status_id'].to_i}))
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
    set_result_set
    status = Status.find(params['set_status'])
     @result = Result.new(message: params['data'], author: current_user.email, status_id: status.id, plan_id: @result_set.plan_id, result_set_id: @result_set.id)
      @result.errors.add(:status, 'Status is disable') if status.disabled
      if @result.errors.empty?
        if @result.save
          @result_set.results << @result
          status.results << @result
          @result_set.update!(status: @result.status_id)
          redirect_to run_result_sets_path(Run.find(@result_set.run_id)), notice: 'Status has changed'
        else
          render json: @result.errors, status: :unprocessable_entity
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
    @result_set = ResultSet.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def result_set_params
    params.require(:result_set).permit(:name, :date, :version)
  end

  def set_run
    @run = Run.find_by_id(params[:run_id])
  end

  def set_plan
    @plan = Plan.find_by_id(params[:plan_id])
  end

  def product_find_by_id
    Product.find_by_id(params.require(:product_id))
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