class AlterChildParentsTableName < ActiveRecord::Migration
  def change
    rename_table :children_parents, :child_parents
  end
end
