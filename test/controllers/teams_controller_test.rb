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
    
    # don't need to test get index
#  test "should get index" do
#    get teams_url
#    assert_response :success
#  end

  test "should get new" do
    login_as_manager
    assert(get new_team_url)
  end

  test "should create team" do
    login_as_manager
    assert_difference('Team.count', 1) do
      post teams_url, params: { team: { name: @team.name } }
    end

    assert_redirected_to edit_members_url(Team.last)
  end

  test "should show team" do
    get team_url(@team)
    assert_response :success
  end

  test "should get edit" do
    assert(get edit_team_url(@team))
  end

  test "should update team name" do
    assert(patch team_url(@team), params: { team: { name: @team.name } })
  end

    # don't need to test destroying a team
#  test "should destroy team" do
#    assert_difference('Team.count', -1) do
#      delete team_url(@team)
#    end
#  end
end
