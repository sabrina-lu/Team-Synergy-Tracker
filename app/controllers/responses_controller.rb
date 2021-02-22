class ResponsesController < ApplicationController
  before_action :set_response, only: [:show, :edit, :update, :destroy]

  # GET /responses
  def index
    @responses = Response.all
  end

  # GET /responses/1
  def show
      #@response = Response.new
  end

  # GET /responses/new
  def new
    @response = Response.new
  end

  # GET /responses/1/edit
  def edit
  end

  # POST /responses
  def create
     
    @response = Response.new(survey_id: response_params[:survey_id], question_number: response_params[:question_number], answer: response_params[:answer])

    if @response.save
      redirect_to @response, notice: 'Response was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /responses/1
  def update
    if @response.update(response_params)
      redirect_to @response, notice: 'Response was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /responses/1
  def destroy
    @response.destroy
    redirect_to responses_url, notice: 'Response was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_response
      @response = Response.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def response_params
      params.permit(:survey_id, :question_number, :answer)
    end
end
