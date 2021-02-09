class AddReferencesToTeamsUsers < ActiveRecord::Migration[6.0]
  def change
      add_foreign_key :teams_users, :users, column: :user_id, primary_key: "id"      
      add_foreign_key :teams_users, :teams, column: :team_id, primary_key: "id"  
  end
end
