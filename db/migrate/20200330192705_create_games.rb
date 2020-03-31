class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
        t.string :name
        t.string :type
        t.integer :user_id
    end
  end
end
