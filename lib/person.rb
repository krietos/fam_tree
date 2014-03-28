class Person < ActiveRecord::Base
  I18n.enforce_available_locales = false
  validates :name, presence: true
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

  def self.validate_person(prompt)
    fail_count = 0
    begin
      if fail_count > 0
       puts "Not a valid input."
      end
      puts prompt
      person = self.find_by_id(gets.chomp)
      fail_count += 1
    end until person != nil
    person
  end
end
