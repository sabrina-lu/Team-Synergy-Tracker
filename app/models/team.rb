class Team < ApplicationRecord
    has_and_belongs_to_many :managers
    has_and_belongs_to_many :users
    has_many :surveys
    has_many :tickets

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
    
    def weekly_survey_team_health(week, current_weekly_survey_due_date)
      count_numerator = 0
      count_total = 0
      surveysToCalc = Survey.where(:team_id => id, :date => current_weekly_survey_due_date-week*7)
      surveysToCalc.each do |survey|
          survey.responses.each do |response|
            count_numerator += response.answer
            count_total += 1 
          end
      end
     
      if count_total == 0
        return 0
      else
        count_denominator = count_total*5
        return '%.2f' % ((count_numerator.to_f/count_denominator.to_f)*100)
      end
    end
    
    def weekly_feedback_team_health(week, current_weekly_survey_due_date)
        count_numerator = 0
        count_total = 0
        start_date = current_weekly_survey_due_date-week*7
        tickets = Ticket.where(:date => start_date-7...start_date, :team => id)
        tickets.each do |ticket|
            count_numerator += ticket.ticket_responses.fifth.answer
            count_total += 1
        end
        
        if count_total == 0
          return 0
        else
          count_denominator = count_total*10
          return '%.2f' % ((count_numerator.to_f/count_denominator.to_f)*100)
        end
    end
    
    def get_total_team_health(week, current_weekly_survey_due_date)
        weekly_survey_team_health = self.weekly_survey_team_health(week, current_weekly_survey_due_date)
        weekly_feedback_team_health = self.weekly_feedback_team_health(week, current_weekly_survey_due_date)
        if (weekly_survey_team_health == 0) 
            return weekly_feedback_team_health
        elsif (weekly_feedback_team_health == 0)
            return weekly_survey_team_health
        else 
            return '%.2f' % (0.8*(weekly_survey_team_health.to_f) + 0.2*(weekly_feedback_team_health.to_f))
        end
    end
end
