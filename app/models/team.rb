class Team < ApplicationRecord
    has_and_belongs_to_many :managers
    has_and_belongs_to_many :users
    has_many :surveys
    has_many :tickets

    validates :name, length: {in: 1..50}, presence: true, allow_blank: false
    
    def get_users_with_tickets(current_user, current_weekly_survey_due_date)
      users_with_tickets = []
      user_tickets = tickets.where(creator_id: current_user.id, :date => current_weekly_survey_due_date-7...current_weekly_survey_due_date)
      user_tickets.each do |ticket|
        users_with_tickets << ticket.users.first
      end
      users_with_tickets << current_user
      return users_with_tickets       
    end
    
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
            if ticket.ticket_responses.exists?
              count_numerator += ticket.ticket_responses.fifth.answer
              count_total += 1
            end
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
    
    def get_health_history(current_weekly_survey_due_date)
      total_weeks = Survey.where(team_id: id).select('distinct(date)').count
      @team_health_history = []
      for i in 0..total_weeks - 1 do 
        @team_health_history << [total_weeks-i, self.get_total_team_health(i, current_weekly_survey_due_date)]
      end  
      return @team_health_history
    end
end
