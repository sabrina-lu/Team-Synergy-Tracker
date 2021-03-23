class TicketResponsesController < ApplicationController
  before_action :set_ticket_response, only: [:show, :edit, :update, :destroy]
end
