class TicketResponsesController < ApplicationController
  before_action :set_ticket_response, only: [:show, :edit, :update, :destroy]

  # GET /ticket_responses
  def index
    @ticket_responses = TicketResponse.all
  end

  # GET /ticket_responses/1
  def show
  end

  # GET /ticket_responses/new
  def new
    @ticket_response = TicketResponse.new
  end

  # GET /ticket_responses/1/edit
  def edit
  end

  # POST /ticket_responses
  def create
    @ticket_response = TicketResponse.new(ticket_response_params)

    if @ticket_response.save
      redirect_to @ticket_response, notice: 'Ticket response was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ticket_responses/1
  def update
    if @ticket_response.update(ticket_response_params)
      redirect_to @ticket_response, notice: 'Ticket response was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ticket_responses/1
  def destroy
    @ticket_response.destroy
    redirect_to ticket_responses_url, notice: 'Ticket response was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket_response
      @ticket_response = TicketResponse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_response_params
      params.fetch(:ticket_response, {})
    end
end
