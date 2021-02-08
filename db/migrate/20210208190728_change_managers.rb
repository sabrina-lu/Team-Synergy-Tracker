class ChangeManagers < ActiveRecord::Migration[6.0]
  def change
      remove_index :managers, :watiam
      add_column(:managers, :manager_id, :integer, null: false, serial: true)
      add_column(:managers, :password, :string, null: false)
      add_index(:managers, :manager_id, unique: true)
  end
end
