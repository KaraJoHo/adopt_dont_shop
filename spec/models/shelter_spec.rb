require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    Pet.destroy_all
    VeterinaryOffice.destroy_all
    Shelter.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application_2 = Application.create!(name: 'Joe Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "Pending")

    @pet_application_2 = PetApplication.create!(pet_id: @pet_1.id, application_id: @application_2.id)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Fancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end
  
    describe '#list_pending' do
      it 'lists shelters with applications that have status as In progress' do
      expect(Shelter.list_pending).to eq([@shelter_1])
      end
    end

    describe '#find_shelter_name_city' do
      it 'finds the name and city of a shelter via a provided argument' do
      expect(Shelter.find_shelter_name_city(@shelter_1.id).first.name).to eq('Aurora shelter')
      expect(Shelter.find_shelter_name_city(@shelter_1.id).first.city).to eq('Aurora, CO')
      expect(Shelter.find_shelter_name_city(@shelter_1.id).first.attributes).to eq({"id"=>nil, "name"=>"Aurora shelter", "city"=>"Aurora, CO"})
      end
    end
  end
  
  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end

    describe '::order_by_reverse_alphabetical' do 
      it 'orders shelters in reverse alphabetical order' do 
        expect(Shelter.order_by_reverse_alphabetical).to eq([@shelter_2, @shelter_3, @shelter_1])
      end
    end

    describe '::order_by_alphabetical pending' do 
      it 'orders shelter with pending applications alphabetically' do 
        Shelter.destroy_all 
        Pet.destroy_all 
        Application.destroy_all
        shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
        shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
        shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
        pet1 = Pet.create!(adoptable: true, age: 46, breed: 'snapping', name: 'Shelly', shelter_id: shelter_1.id, )
        app1 = Application.create!(name: 'Matt Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "Pending")
        petapplication1 = PetApplication.create!(pet_id: pet1.id, application_id: app1.id)
        pet2 = Pet.create!(adoptable: true, age: 46, breed: 'snapping', name: 'Shelly', shelter_id: shelter_2.id, )
        app2 = Application.create!(name: 'Smith Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "Pending")
        petapplication2 = PetApplication.create!(pet_id: pet2.id, application_id: app2.id)

        expect(Shelter.order_by_alphabetical_pending).to eq([shelter_1, shelter_2])
      end
    end
    
    describe '#average_pet_age' do 
      it 'calculates average age for pets at the specific shelter' do 
        expect(@shelter_1.average_pet_age).to eq(4.33)
      end
    end
  end
end
