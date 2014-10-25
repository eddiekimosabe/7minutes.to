class Reads < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :title
  		t.string :excerpt
  		t.string :url
  		t.integer :read_time
  		t.boolean :read?
  		t.integer :user_id

  		t.timestamps
  	end
  end
end
