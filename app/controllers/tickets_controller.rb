class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets/1
  def show
    ticket = Ticket.find(params[:id])
    if !current_user_is_manager
      user_is_involved = ticket.users.include? current_user
      if !(user_is_involved || ticket.creator_id == current_user.id)
        redirect_to user_tickets_path, notice: "You do not have permission to view this ticket."
      end
    end
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(ticket_params)

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end
    
  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end
    
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.require(:ticket).permit(:priority, :type, :category, :description, :date, :creator_id)
    end
end
