class NewParentChildAssociation < ActiveRecord::Migration
  def change
    create_table :children_parents do |t|
      t.column :parent_id, :int
      t.column :child_id, :int
    end
  end
end
