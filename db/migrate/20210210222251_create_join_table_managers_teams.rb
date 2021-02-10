class CreateJoinTableManagersTeams < ActiveRecord::Migration[6.0]
  def change
    create_join_table :managers, :teams do |t|
       t.index [:manager_id, :team_id], unique: true
      # t.index [:team_id, :manager_id]
    end
  end
end
