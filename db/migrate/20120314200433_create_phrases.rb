class CreatePhrases < ActiveRecord::Migration
  def change
    create_table :phrases do |t|
      t.text :input, :null => false
      t.text :output, :null => false
      t.timestamps
    end
  end
end
