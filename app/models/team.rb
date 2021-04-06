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
    
    def any_completed_surveys(current_weekly_survey_due_date)
        any_surveys = self.number_of_completed_surveys(current_weekly_survey_due_date)
        if any_surveys == 0
            return false
        else
            return true
        end
    end
    
    def number_of_completed_surveys(current_weekly_survey_due_date)
       completed_surveys = 0
       users.each do |user|
         survey = Survey.find_by(user_id: user.id, team_id: id, date: current_weekly_survey_due_date)
         if survey && survey.responses.exists?
           completed_surveys += 1
         end
       end
        return completed_surveys
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
        count_communication = 0
        count_behaviour = 0
        count_teamwork = 0
        count_availability = 0
        count_rating = 0
        weekly_feedback = [count_communication, count_behaviour, count_teamwork, count_availability, count_rating]
        count_total = 0
        start_date = current_weekly_survey_due_date-week*7
        tickets = Ticket.where(:date => start_date-7...start_date, :team => id)
        tickets.each do |ticket|
            if ticket.ticket_responses.exists?
                # break up each ticket response
              weekly_feedback[0] += ticket.ticket_responses.first.answer
              weekly_feedback[1] += ticket.ticket_responses.second.answer
              weekly_feedback[2] += ticket.ticket_responses.third.answer
              weekly_feedback[3] += ticket.ticket_responses.fourth.answer
              weekly_feedback[4] += ticket.ticket_responses.fifth.answer
              count_total += 1
            end
        end
        for i in 0..weekly_feedback.length-1 do
        total_points = 3
        if i == 4
          total_points = 10
        end
          weekly_feedback[i] = '%.2f' % ((weekly_feedback[i].to_f/(count_total*total_points))*100)
        end
        if count_total == 0
          # added 0 so the table won't be empty, the negative one is to quickly verify that the array is empty
          return [0, 0, 0, 0, 0, -1]
        else
            # raw sum of feedback data
          return weekly_feedback
        end
    end
    
    def get_total_team_health(week, current_weekly_survey_due_date)
        weekly_survey_team_health = self.weekly_survey_team_health(week, current_weekly_survey_due_date)
        weekly_feedback_team_health = self.weekly_feedback_team_health(week, current_weekly_survey_due_date)
        if (weekly_survey_team_health == 0) 
            return '%.2f' % (sum_weekly_feedback_team_health(weekly_feedback_team_health))
        elsif (weekly_feedback_team_health[-1] == -1)
            return '%.2f' % (weekly_survey_team_health)
        else 
            calculated_weekly_feedback_health = sum_weekly_feedback_team_health(weekly_feedback_team_health)
            return '%.2f' % (0.8*(weekly_survey_team_health.to_f) + 0.2*(calculated_weekly_feedback_health.to_f))
        end
    end
    
    def get_health_history(current_weekly_survey_due_date)
      total_weeks = Survey.where(team_id: id).select('distinct(date)').count
      @team_health_history = []
      for i in 0..total_weeks - 1 do 
        due_date = current_weekly_survey_due_date - 7*i
        interval = "#{due_date-7} - #{due_date-1}"
        feedback_health = self.weekly_feedback_team_health(i, current_weekly_survey_due_date)
        survey_health = self.weekly_survey_team_health(i, current_weekly_survey_due_date)
        total_health = self.get_total_team_health(i, current_weekly_survey_due_date)
        @team_health_history << [interval, feedback_health[0], feedback_health[1], feedback_health[2], feedback_health[3], survey_health, total_health]
      end  
      return @team_health_history
    end
    
    def sum_weekly_feedback_team_health(feedbacks)
        if feedbacks == []
            return 0
        else
            sum_weekly_feedback = 0.00
            # exclude the total count and rating
            for i in 0..feedbacks.length-2
                # calculate average in category responses and give weight of 10%
                sum_weekly_feedback += (feedbacks[i].to_f)*0.1
            end
            # calculate average in rating responses and give weight of 60%
            sum_weekly_feedback += (feedbacks[4].to_f)*0.6
            return  '%.2f' % (sum_weekly_feedback)
        end
    end
end
