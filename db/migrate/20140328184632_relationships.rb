class Relationships < ActiveRecord::Migration
  def change
    rename_table :child_parents, :relationships
  end
end
