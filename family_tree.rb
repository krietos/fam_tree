require 'bundler/setup'
require 'pry'
Bundler.require(:default)
require './lib/person'
require './lib/child'
require './lib/parent'
require './lib/marriage'
require './lib/relationship'
require './lib/getsreplace'
# Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  system('clear')
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'
  menu
end

def menu
  loop do
    puts "\n\nPress a to add a family member."
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press c to identify a parent-child relationship.'
    puts "Press p to see who someone's parents are."
    puts "Press g to see who someone's grandparents are."
    puts "Press k to see who someone's children are."
    puts "Press b to see who someone's grandchildren are."
    puts "Press h to see who someone's half-siblings are."
    puts "Press f to see who someone's full-siblings are."
    puts "Press au to see who someone's aunts and uncles are."
    puts "Enter 'cousin' to see who someone's cousins are."
    puts "Press d to divorce a couple."
    puts 'Press e to exit.'
    choice = gets.chomp

    case choice
    when 'a'
      add_person
    when 'l'
      list
    when 'm'
      add_marriage
    when 's'
      show_marriage
    when 'c'
      add_parents
    when 'p'
      show_parents
    when 'g'
      show_grandparents
    when 'k'
      show_children
    when 'b'
      show_grandchildren
    when 'h'
      show_half_siblings
    when 'f'
      show_full_siblings
    when 'au'
      show_aunts_uncles
    when 'cousin'
      show_cousins
    when 'd'
      make_divorce
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  person = Person.new(:name => name)
  if person.save
    puts name + " was added to the family tree.\n\n"
  else
    puts 'Please enter a name.'
    add_person
  end
end

def add_marriage
  list
  spouse1 = assign_spouse('first')
  spouse2 = assign_spouse('second')
  marriage = Marriage.create({:divorced => false, :person1_id => spouse1.id, :person2_id => spouse2.id})
  spouse1.update({:spouse_id => spouse2.id})
  spouse2.update({:spouse_id => spouse1.id})
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def assign_spouse(number)
  puts "What is the number of the #{number} spouse?"
  spouse = Person.find_by_id(gets.chomp)
  if spouse != nil
    return spouse
  else
    puts 'Enter a valid choice'
    assign_spouse(number)
  end
end

def add_parents
  list
  # fail_count = 0
  # begin
  #   if fail_count > 0
  #     puts 'That was not a valid input.'
  #   end
  #   puts 'What is the number of the child?'
  #   child = Person.find_by_id(gets.chomp)
  #   fail_count += 1
  # end until child != nil
  person = Person.validate_person("What is the number of the child?")
  continue = nil
  parents = []
  until continue == 'n'
    puts 'What is the number of the parent?'
    parent = Person.find(gets.chomp)
    child_parent = Relationship.create({ child_id: child.id, parent_id: parent.id})
    puts "#{parent.name} has been added as a parent of #{child.name}."
    puts "Would you like to add another parent for #{child.name}? (Y/N)"
    parents << "#{parent.name}"
    continue = gets.chomp.downcase
  end
  parent_string = parents.join(" and ")
  puts "#{parent_string} have been added as parents of #{child.name}."
end

def show_parents
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you his or her parents.")
  parents = person.parents
  if parents[0].nil?
    puts person.name + "'s parents haven't been added to the family tree."
  else
    found_parents = []
    parents.each do |parent|
      found_parents << parent.name
    end
    found_parent_string = found_parents.join(" and ")
    puts "Parent(s) of #{person.name}: #{found_parent_string}"
  end
end

def show_grandparents
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you their grandparents.")
  grandparents = person.grandparents
  grandparent_names = []
  grandparents.each do |grandparent|
    grandparent_names << grandparent.name
  end
  puts "Grandparent(s) of #{person.name}: #{grandparent_names.join(' and ')}"
end

def show_children
  list
  person = Parent.validate_person("Enter the number of the relative and I'll show you his or her children.")
  children = person.childs
  if children[0].nil?
    puts person.name + "'s children haven't been added to the family tree."
  else
    found_children = []
    children.each do |child|
      found_children << child.name
    end
    found_child_string = found_children.join(" and ")
    puts "child(ren) of #{person.name}: #{found_child_string}"
  end
end

def show_grandchildren
  list
  person = Parent.validate_person("Enter the number of the relative and I'll show you their grandchildren.")
  grandchildren = person.grandchildren
  grandchildren_names = []
  grandchildren.each do |grandchild|
    grandchildren_names << grandchild.name
  end
  puts "Grandchild(ren) of #{person.name}: #{grandchildren_names.join(' and ')}"
end

def show_half_siblings
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you their half-siblings.")
  half_siblings = person.half_siblings
  half_siblings_names = []
  half_siblings.each do |half_sibling|
    half_siblings_names << half_sibling.name
  end
  puts "The half-sibling(s) of #{person.name}: #{half_siblings_names.join(' and ')}"
end

def show_full_siblings
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you their full-siblings.")
  full_siblings = person.full_siblings
  full_siblings_names = []
  full_siblings.each do |full_sibling|
    full_siblings_names << full_sibling.name
  end
  puts "The full-sibling(s) of #{person.name}: #{full_siblings_names.join(' and ')}"
end

def show_aunts_uncles
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you their uncles and aunts.")
  aunts_uncles = person.aunts_uncles
  aunts_uncles_names = []
  aunts_uncles.each do |aunt_uncle|
    aunts_uncles_names << aunt_uncle.name
  end
  puts "The aunt(s) and uncle(s) of #{person.name}: #{aunts_uncles_names.join(' and ')}"
end

def show_cousins
  list
  person = Child.validate_person("Enter the number of the relative and I'll show you their cousins.")
  cousins = person.cousins
  cousins_names = []
  cousins.each do |cousin|
    cousins_names << cousin.name
  end
  puts "The cousin(s) of #{person.name}: #{cousins_names.join(' and ')}"
end

def make_divorce
  list
  person = Person.validate_person("Enter the number of the first spouse.")
  spouse = Person.find(person.spouse_id)
  if spouse.nil?
    puts "#{person.name} is not presently married."
  else
    marriage = Marriage.where({:person1_id => person.id, :person2_id => spouse.id, :divorced => false}).first
    if marriage.nil?
      marriage = Marriage.where({:person1_id => spouse.id, :person2_id => person.id, :divorce => false}).first
    end
    puts "#{person.name} is currently married to #{spouse.name}."
    puts "Should they divorce? (Y/N)"
    divorce = gets.chomp.downcase
    case divorce
    when 'y'
      marriage.update({:divorced => true})
      spouse.update({:spouse_id => nil})
      person.update({:spouse_id => nil})
      puts "#{person.name} is no longer married to #{spouse.name}."
    when 'n'
      puts "We wish #{person.name} and #{spouse.name} the best of luck with their relationship."
    else
      puts "Not a valid input."
    end
  end
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  person = Person.validate_person("Enter the number of the relative and I'll show you who they're married to.")
  if person.spouse_id.nil?
    puts person.name + " is single and lookin' to mingle."
  else
    found_spounse = person.spouse
    puts person.name + " is married to " + found_spounse.name + "."
  end
  previous_spouses = person.previous_marriages
  previous_spouse_names = []
  previous_spouses.each do |spouse|
    previous_spouse_names << spouse.name
  end
  if previous_spouses.length > 0
    puts person.name + " was previously married to: #{previous_spouse_names.join(' and ')}"
  end
end

welcome
