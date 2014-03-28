class AddPerson1Person2ToMarriage < ActiveRecord::Migration
  def change
    add_column :marriages, :person1_id, :int
    add_column :marriages, :person2_id, :int
  end
end
