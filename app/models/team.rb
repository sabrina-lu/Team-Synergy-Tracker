class Team < ApplicationRecord
    has_and_belongs_to_many :managers
    has_and_belongs_to_many :users
    has_many :surveys

    validates :name, length: {in: 1..50}, presence: true, allow_blank: false
    
    def get_survey_completion_ratio(current_weekly_survey_due_date)
       completed_surveys = 0
       users.each do |user|
         survey = Survey.find_by(user_id: user.id, team_id: id, date: current_weekly_survey_due_date)
         if survey && survey.responses.exists?
           completed_surveys += 1
         end
       end
       return "#{completed_surveys}/#{users.count}"
    end
end
