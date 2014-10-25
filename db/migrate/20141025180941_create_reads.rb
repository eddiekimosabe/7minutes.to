class CreateReads < ActiveRecord::Migration
  def change
    create_table :reads do |t|

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
