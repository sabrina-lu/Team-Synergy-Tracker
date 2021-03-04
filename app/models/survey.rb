class Survey < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :responses
  
  # https://stackoverflow.com/questions/7621322/ruby-find-next-thursday-or-any-day-of-the-week
  def self.get_current_survey_due_date(current_date)
    if current_date.saturday?
        return current_date + 7
    else
        return 6 > current_date.wday ? current_date + (6 - current_date.wday) : current_date.next_week.next_day(6)
    end
  end
  
  def self.get_next_survey_due_date(current_date)
    if current_date.saturday?
        return current_date + 7
    elsif current_date.sunday?
        return current_date + 6
    else
        return 6 > current_date.wday ? current_date + (6 - current_date.wday) + 7 : current_date.next_week.next_day(6)
    end
  end
end
