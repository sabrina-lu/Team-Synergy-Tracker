class Response < ApplicationRecord
    belongs_to :survey
    
    validates :answer, presence: true, inclusion: {in: 1..5}, allow_blank: false
  
    def self.permission_to_response(response_id, current_user)
        survey_id = Response.find(response_id).survey_id
        user_id = Survey.find(survey_id).user_id
        survey_owner = User.find(user_id)
        if current_user.watiam == survey_owner.watiam
            return true
        else 
            return false
        end
  end
end
