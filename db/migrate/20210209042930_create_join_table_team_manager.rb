class CreateJoinTableTeamManager < ActiveRecord::Migration[6.0]
  def change
    create_join_table :teams, :managers do |t|
       t.index [:team_id, :manager_id], unique: true
      # t.index [:manager_id, :team_id]
    end
  end
end
