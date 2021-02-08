class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members, id: false do |t|
      t.references :team, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.index [:team_id, :user_id], unique: true
      t.timestamps
    end
  end
end