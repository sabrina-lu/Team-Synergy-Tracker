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
    
    
  test "should get index" do
    get teams_url
    assert_response :success
  end

  test "should get new" do
      flunk('Not done')
    get new_team_url
    assert_response :success
  end

  test "should create team" do
      flunk('Not done')
    assert_difference('Team.count') do
      post teams_url, params: { team: { name: @team.name } }
    end

    assert_redirected_to team_url(Team.last)
  end

  test "should show team" do
    get team_url(@team)
    assert_response :success
  end

  test "should get edit" do
    get edit_team_url(@team)
    assert_response :success
  end

  test "should update team" do
      flunk('Not done')
    patch team_url(@team), params: { team: { name: @team.name } }
    assert_redirected_to team_url(@team)
  end

  test "should destroy team" do
      flunk('Not done')
    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to teams_url
  end
end
