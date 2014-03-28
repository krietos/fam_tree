class Parent < Person
  has_many :relationships, :foreign_key => "parent_id"
  has_many :childs, through: :relationships

  def grandchildren
    grandchildren = []
    self.childs.each do |child|
      child_as_parent = Parent.find(child.id)
      child_as_parent.childs.each do |grandchild|
        grandchildren << grandchild
      end
    end
    grandchildren
  end
end
