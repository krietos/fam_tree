class Person < ActiveRecord::Base
  has_one :spouse, class_name: "Person", foreign_key: "spouse_id"
  has_many :parents, class_name: "Person", through: "parents_children", foreign_key: "parent_id"
  has_many :children, class_name: "Person", through: "parents_children", foreign_key: "child_id"
end
