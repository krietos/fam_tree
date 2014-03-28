class ChangeMarriageIdToSpouseId < ActiveRecord::Migration
  def change
    remove_column :people, :marriage_id
    add_column :people, :spouse_id, :int
  end
end
