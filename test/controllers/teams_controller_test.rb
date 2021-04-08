require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do 
    setup_surveys_responses #includes responses and surveys
  end

  # manager > team # > add/remove users > removing a user
  test "should remove user from team with response history" do
     assert_difference('Team.joins(:users).count', -1) do
     post confirm_remove_member_url (@team), params: { user_id: @user.id, id: @team.id}
    end
  end
    
  # manager > team # > add/remove users > removing a user
  test "should remove user from team without response history" do
      setup_users_manager_teams
      s1 = Survey.create(date: "10/02/2020")
      @user.surveys << [s1]
      @team.surveys << [s1]
      @user.save
      @team.save
      assert_difference('Team.joins(:users).count', -1) do
      post confirm_remove_member_url (@team), params: { user_id: @user.id, id: @team.id}
    end
  end
    
  # manager > team # > add/remove users > adding a user
  test "should add user to a team" do
      @user = User.create(watiam: "emmalin", first_name: "Emma", last_name: "Lin", password: "Password") 
      post confirm_add_member_url (@team), params:{ user_id: @user.id, id: @team.id}
      assert_redirected_to edit_members_url(@team)
  end

  test "should get new" do
    login_as_manager
    assert(get new_team_url)
  end
    
  test "should redirect user to user dashboard when trying to edit members on a team" do
    login_as_user
    get edit_members_url(@team)
    assert_redirected_to user_dashboard_path
    assert_equal "Please login as a manager to view this page.", flash[:notice] 
  end
    
  test "should redirect user to user dashboard when trying to create a new team" do
    login_as_user
    get new_team_url
    assert_redirected_to user_dashboard_path
    assert_equal "Please login as a manager to view this page.", flash[:notice] 
  end  
    
  test "should create team" do
    login_as_manager
    assert_difference('Team.count', 1) do
      post teams_url, params: { team: { name: @team.name } }
    end

    assert_redirected_to edit_members_url(Team.last)
  end

  test "should get edit" do
    assert(get edit_team_url(@team))
  end

  test "should update team name" do
    assert(patch team_url(@team), params: { team: { name: @team.name } })
  end
end
