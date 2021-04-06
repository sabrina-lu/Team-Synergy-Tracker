class Response < ApplicationRecord
    belongs_to :survey
    
    validates :answer, presence: {strict: true}, inclusion: {in: 1..5, message: "%{value} is not a valid score"}, numericality: {only_integer: true}, format: {with: /\A\d{1}?\z/}, allow_nil: false, allow_blank: false
  
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
