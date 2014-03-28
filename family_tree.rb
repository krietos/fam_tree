require 'bundler/setup'
require 'pry'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts 'Press c to identify a parent-child relationship.'
    puts "Press p to see who someone's parents are."
    puts "Press g to see who someone's grandparents are."
    puts "Press k to see who someone's children are."
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
    when 'e'
      exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  marriage = Marriage.create({:divorced => false, :person1_id => spouse1.id, :person2_id => spouse2.id})
  spouse1.update({:spouse_id => spouse2.id})
  spouse2.update({:spouse_id => spouse1.id})
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def add_parents
  list
  puts 'What is the number of the child?'
  child = Person.find(gets.chomp)
  puts 'What is the number of the first parent?'
  parent1 = Person.find(gets.chomp)
  child.update({:parent1_person_id => parent1.id})
  puts 'What is the number of the first parent?'
  parent2 = Person.find(gets.chomp)
  child.update({:parent2_person_id => parent2.id})
  puts "The parents of #{child.name} are #{parent1.name} and #{parent2.name}."
end

def show_parents
  list
  puts "Enter the number of the relative and I'll show you his or her parents."
  person = Person.find(gets.chomp)
  if person.parent1_person_id.nil?
    puts person.name + "'s parents haven't been added to the family tree."
  else
    parent1 = Person.find(person.parent1_person_id)
    parent2 = Person.find(person.parent2_person_id)
    puts "#{parent1.name} and #{parent2.name} are the biological parents of #{person.name}."
  end
end

def show_grandparents
  list
  puts "Enter the number of the relative and I'll show you their grandparents."
  person = Person.find(gets.chomp)
  parent1 = Person.find(person.parent1_person_id)
  parent2 = Person.find(person.parent2_person_id)
  grandparent1 = Person.find(parent1.parent1_person_id)
  grandparent2 = Person.find(parent1.parent2_person_id)
  grandparent3 = Person.find(parent2.parent1_person_id)
  grandparent4 = Person.find(parent2.parent2_person_id)
  puts "The grandparents of #{person.name} are #{grandparent1.name}, #{grandparent2.name}, #{grandparent3.name}, #{grandparent4.name}."
end

def show_children
  list
  puts "Enter the number of the relative and I'll show you their children."
  person = Person.find(gets.chomp)
  child = Person.find
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
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  if person.spouse_id.nil?
    puts person.name + " is single and lookin' to mingle."
  else
    found_spounse = person.spouse
    puts person.name + " is married to " + found_spounse.name + "."
  end
end

menu
