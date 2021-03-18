class User < ApplicationRecord
    attr_accessor :flag
    
    has_and_belongs_to_many :teams
    has_many :surveys
    has_and_belongs_to_many :tickets
    has_secure_password
  
    validates :first_name, presence: true, allow_blank: false
    validates :last_name, presence: true, allow_blank: false
    validates :watiam, format: {without: /\s/}, presence: true, allow_blank: false
    validates :password, length: {in: 6..25}, on: :create, format: {without: /\s/}, allow_blank: false, presence: true

    def full_name_with_watiam
        "#{watiam}: #{first_name} #{last_name}"
    end
    
    def self.get_ordered_survey_indicator(team, current_weekly_survey_due_date)
      ordered_users = []
      team.users.each { |user|
        survey = Survey.find_by(user_id: user.id, team_id: team.id, date: current_weekly_survey_due_date)
        if survey && survey.responses.exists?
          ordered_users << [user, "Yes"]
        else
          ordered_users.insert(0, [user, "No"]) 
        end
      }
      return ordered_users
    end
end
