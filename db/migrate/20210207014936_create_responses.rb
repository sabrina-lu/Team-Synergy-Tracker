class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
      t.integer :survey_id, null:false
      t.integer :question_number, null:false
      t.integer :answer, null:false

      t.timestamps
    end
  end
end
