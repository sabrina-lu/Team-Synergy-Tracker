require 'test_helper'

class ManagerTest < ActiveSupport::TestCase
  test "Should successfully create a manager" do
    assert @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "Password").valid?
  end
  
  test "Should successfully create a manager with minimum password length" do
    assert @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "onetwo").valid?
  end
  
  test "Should fail to create a manager with too short password length" do
    assert_not @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "short").valid?
  end
  
  test "Should fail to create a manager with a blank password" do
    assert_not @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "").valid?
  end
  
  test "Should fail to create a manager with null password" do
    assert_not @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: nil).valid?
  end
  
  test "Should fail to create a manager with too long password" do
    assert_not @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "fI94Xfq*7EJzLA!h@VGSFahACC").valid?
  end
  
  test "Should successfully create a manager with max length password" do
    assert @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "Yl93&OJs6YqI*1CO7u@jhPcvI").valid?
  end
  
  test "Should fail to create a manager with a space in the password" do
    assert_not @manager = Manager.create(watiam: "m1", first_name: "manager1", last_name: "one", password: "pass word").valid?
  end
  
  test "Should fail to create a manager with a space in the watiam" do
    assert_not @manager = Manager.create(watiam: "kasj d90p", first_name: "manager1", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a manager with a blank watiam" do
    assert_not @manager = Manager.create(watiam: "", first_name: "manager1", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a manager with a blank first name" do
    assert_not @manager = Manager.create(watiam: "hmm1", first_name: "", last_name: "one", password: "password").valid?
  end
  
  test "Should fail to create a manager with a blank last name" do
    assert_not @manager = Manager.create(watiam: "hmm1", first_name: "manager1", last_name: "", password: "password").valid?
  end
end
