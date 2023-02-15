require 'rails_helper'

RSpec.describe "Admin Shelters Show Page" do 
  before(:each) do 
    Shelter.destroy_all 
    Pet.destroy_all
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
  end
  describe 'as a visitor' do 
    it 'has a section for statisitcs with average of adoptable pets at that shelter' do 
      visit "/admin/shelters/#{@shelter_1.id}"

      within(".statistics") do 
        expect(page).to have_content("Statistics")
        expect(page).to have_content("#{@shelter_1.name}: 4.33")
      end
    end
  end
end