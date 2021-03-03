class CreateResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :responses do |t|
        # https://stackoverflow.com/questions/46777875/how-do-i-create-a-foreign-key-with-a-cascading-delete-constraint-in-my-rails-5-m
      t.references :survey, null: false, foreign_key: {on_delete: :cascade}
      t.integer :question_number, null:false
      t.integer :answer, null:false
      
      t.timestamps
    end
  end
end



# foreign_key: true
