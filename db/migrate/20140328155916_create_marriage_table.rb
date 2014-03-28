class CreateMarriageTable < ActiveRecord::Migration
  def change
    create_table :marriages do |t|
      t.column :divorced, :boolean
    end

    remove_column :people, :spouse_id
    add_column :people, :marriage_id, :int
    add_column :people, :parent1_person_id, :int
    add_column :people, :parent2_person_id, :int
  end
end
