class ApplicationController < ActionController::Base
    include SessionsHelper
    
    CURRENT_SURVEY_DUE_DATE = Survey.get_current_survey_due_date(Date.today)
    NEXT_SURVEY_DUE_DATE = Survey.get_next_survey_due_date(Date.today)
end
