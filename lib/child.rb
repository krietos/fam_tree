class Child < Person
  has_many :relationships, :foreign_key => "child_id"
  has_many :parents, through: :relationships

  def grandparents
    grandparents = []
    self.parents.each do |parent|
      parent_as_child = Child.find(parent.id)
      parent_as_child.parents.each do |grandparent|
        grandparents << grandparent
      end
    end
    grandparents
  end

  def half_siblings
    half_siblings = []
    self.parents.each do |person|
      parent_person = Parent.find(person.id)
      parent_person.childs.each do |child|
        if child.id != self.id
          child = Child.find(child.id)
          parents1 = child.parents
          parents2 = self.parents
          if parents1 != parents2
            half_siblings << child
          end
        end
      end
    end
    half_siblings
  end

  def full_siblings
    full_siblings = []
    self.parents.each do |person|
      parent_person = Parent.find(person.id)
      parent_person.childs.each do |child|
        if child.id != self.id
          child = Child.find(child.id)
          parents1 = child.parents
          parents2 = self.parents
          if parents1 == parents2
            full_siblings << child
          end
        end
      end
    end
    full_siblings.uniq
  end

  def aunts_uncles
    aunts_uncles = []
    self.parents.each do |parent|
      parent.full_siblings.each do |sibling|
        aunts_uncles << sibling
      end
    end
    aunts_uncles
  end

  def cousins
    cousins = []
    self.aunts_uncles.each do |aunt_uncle|
      aunt_uncle_as_parent = Parent.find(aunt_uncle.id)
      aunt_uncle_as_parent.childs.each do |cousin|
        if cousin.id != self.id
          cousins << cousin
        end
      end
    end
    cousins.uniq
  end
end












