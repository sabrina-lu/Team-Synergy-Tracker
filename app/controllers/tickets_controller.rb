class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets/new
  def new
    @from = params[:from]
    @ticket = Ticket.new
    @team = Team.find(params[:id])
      if current_user_is_manager 
          redirect_to manager_dashboard_path, alert: "You do not have permission to create tickets."
      elsif !current_user.teams.include?(@team)
          redirect_to user_dashboard_path, alert: "You do not have permission to create this ticket."
      else
          @users_to_not_select = @team.get_users_with_tickets(current_user, CURRENT_SURVEY_DUE_DATE)
      end
  end

  # POST /tickets
  def create
      begin
        @ticket = Ticket.new(date: params[:date])
        @ticket.creator = User.find(params[:creator_id])
        @ticket.team = Team.find_by(:id => params[:id])
        if !params[:users]
          redirect_to new_team_ticket_url(@ticket.team, ticket_params), alert: "You Must Add a User to this Ticket."
        else
          @users = User.find(params[:users])
          @ticket.users << @users
          if ticket_not_valid(params[:answer1], params[:answer2], params[:answer3], params[:answer4]) || rating_not_valid(params[:answer5])
            redirect_to new_team_ticket_path(@ticket.team, ticket_params), alert: "Invalid response scores. Please fix and resubmit"
          else
            if @ticket.save            
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
       end
     end
  end
    
  # Check if feedback rating scores are valid for ticket submissions
  def ticket_not_valid(*args)
    for i in args
      i = i.to_i
      if i < 1 || i > 3
        return true
      end
    end
    return false
  end
  
  # Check if overall rating score is valid for tickets submission
  def rating_not_valid(overall_rating)
    overall_rating = overall_rating.to_i
    if overall_rating < 1 || overall_rating > 10
      return true
    end
    return false
  end
      
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def ticket_params
      params.permit(:date, :creator_id, :answer1, :answer2, :answer3, :answer4, :answer5, :from)
    end
end
