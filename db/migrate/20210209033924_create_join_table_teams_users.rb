class CreateJoinTableTeamsUsers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :teams, :users do |t|
      # t.index [:team_id, :user_id]
      t.index [:user_id, :team_id], unique: true
    end
  end
end
