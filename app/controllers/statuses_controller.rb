class StatusesController < ApplicationController
  before_action :set_status, only: [:show, :edit, :update, :disable]
  acts_as_token_authentication_handler_for User
  # GET /statuses
  # GET /statuses.json
  def index
    @statuses = Status.all
    @status = Status.new
  end

  # GET /statuses/new
  def new
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(status_params)
    respond_to do |format|
      if @status.save
        format.json { render :json => @status }
        format.html { redirect_to '/settings/status_settings_title', notice: 'Status was successfully created.' }
        format.json { render :show, status: :created, location: @status }
      else
        format.html { render :new }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /statuses/1
  # PATCH/PUT /statuses/1.json
  def update
    respond_to do |format|
      if @status.update(status_params)
        format.json { render :json => @status }
        format.html { redirect_to statuses_path, notice: 'Status was successfully updated.' }
        format.json { render :show, status: :ok, location: @status }
      else
        format.html { render :edit }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end


  def disable
    @status.update(disabled: true) unless @status.main_status
    respond_to do |format|
      format.html { redirect_to statuses_url, notice: 'Status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def status_params
    params.require(:status).permit(:name, :color)
  end

  public
  def get_all_statuses
    status_json = {}
    Status.all.each do |current_status|
      status_json.merge!(current_status.id => {'name' => current_status.name,
                                               'color' => current_status.color,
                                               'created_at' => current_status.created_at,
                                               'updated_at' => current_status.updated_at})
    end
    render :json => status_json
  end

  def get_statuses_by_param
    status_json = {}
    find_params = JSON.parse(params['param'].gsub('=>', ':'))
    statuses = Status.find_by(find_params)
    if statuses.nil?
      render :json => {}
    else
      statuses = [statuses] until statuses.is_a?(Array)
      statuses.each do |current_status|
        status_json.merge!(current_status.id => {'name' => current_status.name,
                                                 'color' => current_status.color,
                                                 'created_at' => current_status.created_at,
                                                 'updated_at' => current_status.updated_at})
      end
      render :json => status_json
    end
  end

  def status_exist?
    status_json = {:status_exist => "#{Status.exists?(:name => params['name'])}"}
    render :json => status_json
  end
end
