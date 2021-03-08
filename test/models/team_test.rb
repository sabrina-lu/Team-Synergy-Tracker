require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "Should successfully create a team with a valid name" do
    assert @team = Team.create(name: "Team 3").valid?
  end
  
  test "Should fail to create a team with a blank name" do
    assert_not @team = Team.create(name: "").valid?
  end
  
  test "Should fail to create a team with a null name" do
    assert_not @team = Team.create(name: nil).valid?
  end
  
  test "Should fail to create a team with a too long name" do
    assert_not @team = Team.create(name: "This is a team name that is way too long and should be so much shorter").valid?
  end
  
  test "Should fail to create a team with just whitespace for its name" do
    assert_not @team = Team.create(name: "          ").valid?
  end
end
