class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets/1
  def show
    ticket = Ticket.find(params[:id])
    responses = []
    responses << TicketResponse.find(ticket_id = ticket.id).answer
    @responses_to_words = []
    for i in 0..responses.length - 2 
        if responses[i] == -1
            @responses_to_words << "poor"
        elsif responses[i] == 0
            @responses_to_words << "typical"
        elsif responses[i] == 1
            @responses_to_words << "great"
        end
    end
    @responses_to_words << responses.last
      
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
    @team = Team.find(params[:id])
  end

  # GET /tickets/1/edit
  def edit
    if (!(current_user.id == @ticket.creator_id) || current_user_is_manager)
      redirect_to @ticket, notice: "You do not have permission to edit this ticket."
    end
  end

  # POST /tickets
  def create
    @ticket = Ticket.new(date: params[:date])
    @ticket.creator = User.find(params[:creator_id])
    @ticket.team = Team.find_by(:id => params[:id]) #fix this
        if @ticket.save
          users = params[:users]
            if users
              users.drop(1).each do |temp_user| 
              @users = User.find(temp_user.to_i)
              @ticket.users << @users
            end
          end
            # add responses to the ticket
            TicketResponse.create(ticket_id: @ticket.id, question_number: 1, answer: params[:answer1])
            TicketResponse.create(ticket_id: @ticket.id, question_number: 2, answer: params[:answer2])
            TicketResponse.create(ticket_id: @ticket.id, question_number: 3, answer: params[:answer3])
            TicketResponse.create(ticket_id: @ticket.id, question_number: 4, answer: params[:answer4])
            TicketResponse.create(ticket_id: @ticket.id, question_number: 5, answer: params[:answer5])
            
            redirect_to user_dashboard_url, notice: 'Ticket was successfully created.'
        else
          render :new
        end 
  end
    
  # PATCH/PUT /tickets/1
  def update
    if @ticket.update(ticket_params || params[:ticket][:users])
        if @ticket.users != params[:ticket][:users]
            @ticket.users.clear()
            users = params[:ticket][:users]
            if users
              users.drop(1).each do |temp_user| 
              @users = User.find(temp_user.to_i)
              @ticket.users << @users
            end
            end
            redirect_to @ticket, notice: 'Ticket was successfully updated.'
        else
            redirect_to @ticket, notice: 'Ticket was successfully updated.'
        end 
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
      params.require(:ticket).permit(:date, :creator_id, :answer1, :answer2, :answer3, :answer4, :answer5)
    end
end
