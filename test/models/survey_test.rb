require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
    
  # get_current_survey_due_date(current_date)
  # 1. used to get current week's survey due date (Saturday)
  # 2. used to create the FIRST week's survey due date (Intialize a team)
  def test_should_get_correct_current_survey_due_date    
    #base cases 
    #1. if today is Monday 2021/3/1, should return Saturday 2021/3/6
    assert_equal Date.new(2021,3,6), Survey.get_current_survey_due_date(Date.new(2021,3,1))
      
    #2. if today is Friday 2021/3/5, should return Saturday 2021/3/6
    assert_equal Date.new(2021,3,6), Survey.get_current_survey_due_date(Date.new(2021,3,5))
  
    #3. if today is Saturday 2021/3/6, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_current_survey_due_date(Date.new(2021,3,6))
    
    #4. if today is Sunday 2021/3/7, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_current_survey_due_date(Date.new(2021,3,7))
      
    #edge cases  
    #1. if today is Tuesday 2021/3/30, should return Saturday 2021/4/3 (during the week it turns another month)
    assert_equal Date.new(2021,4,3), Survey.get_current_survey_due_date(Date.new(2021,3,30))
    
    #2. if today is Friday 2021/12/31, should return Saturday 2022/1/1 (during the week it turns another year)
    assert_equal Date.new(2022,1,1), Survey.get_current_survey_due_date(Date.new(2021,12,31))
  end
  
  # get_next_survey_due_date(current_date)
  # 1. used to create next week's survey due date
  # 2. used to check if next week's survey has already been created
   def test_should_get_correct_next_survey_due_date    
    #base cases  
    #1. if today is Monday 2021/3/1, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_next_survey_due_date(Date.new(2021,3,1))
      
    #2. if today is Friday 2021/3/5, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_next_survey_due_date(Date.new(2021,3,5))
  
    #3. if today is Saturday 2021/3/6, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_next_survey_due_date(Date.new(2021,3,6))
    
    #4. if today is Sunday 2021/3/7, should return Saturday 2021/3/13
    assert_equal Date.new(2021,3,13), Survey.get_next_survey_due_date(Date.new(2021,3,7))
    
    #edge cases  
    #1. if today is Tuesday 2021/3/30, should return Saturday 2021/4/10 (during the week it turns another month)
    assert_equal Date.new(2021,4,10), Survey.get_next_survey_due_date(Date.new(2021,3,30))
    
    #2. if today is Friday 2021/12/31, should return Saturday 2022/1/8 (during the week it turns another year)
    assert_equal Date.new(2022,1,8), Survey.get_next_survey_due_date(Date.new(2021,12,31))
  end
end
