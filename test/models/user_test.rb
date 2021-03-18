require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Should successfully create a user" do
    assert @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "Password").valid?
  end
  
  test "Should successfully create a user with minimum password length" do
    assert @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "onetwo").valid?
  end
  
  test "Should fail to create a user with too short password length" do
    assert_not @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "short").valid?
  end
  
  test "Should fail to create a user with null password" do
    assert_not @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: nil).valid?
  end
  
  test "Should fail to create a user with too long password" do
    assert_not @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "fI94Xfq*7EJzLA!h@VGSFahACC").valid?
  end
  
  test "Should successfully create a user with max length password" do
    assert @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "Yl93&OJs6YqI*1CO7u@jhPcvI").valid?
  end
  
  test "Should fail to create a user with a space in the password" do
    assert_not @user = User.create(watiam: "u1", first_name: "user1", last_name: "one", password: "pass word").valid?
  end
  
  test "Should fail to create a user with a space in the watiam" do
    assert_not @user = User.create(watiam: "kasj d90p", first_name: "user1", last_name: "one", password: "password").valid?
  end
  
end
