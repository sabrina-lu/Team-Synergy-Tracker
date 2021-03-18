class ApplicationController < ActionController::Base
    include SessionsHelper
    
    CURRENT_SURVEY_DUE_DATE = Survey.get_current_survey_due_date(Date.new(2021,3,30))
end
