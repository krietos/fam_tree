class Person < ActiveRecord::Base
  has_one :spouse, class_name: "Person", foreign_key: "spouse_id"

  def previous_marriages
    previous_spouses = []
    Marriage.where({:person1_id => self.id, :divorced => true}).each do |failed_marriage|
      previous_spouses << Person.find(failed_marriage.person2_id)
    end
    Marriage.where({:person2_id => self.id, :divorced => true}).each do |failed_marriage|
      previous_spouses << Person.find(failed_marriage.person1_id)
    end
    previous_spouses.uniq
  end
end
