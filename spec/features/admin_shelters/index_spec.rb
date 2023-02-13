require 'rails_helper'

RSpec.describe "Admin Shelters Index" do 
  describe 'When visiting admin shelters index (/admin/shelters)' do
    it 'has all the shelters in the system in reverse alphabetical order' do 
      Shelter.destroy_all
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      visit "/admin/shelters"

      expect(page).to have_content(shelter_1.name)
      expect(page).to have_content(shelter_2.name)
      expect(page).to have_content(shelter_3.name)

      expect(shelter_2.name).to appear_before(shelter_3.name)
      expect(shelter_3.name).to appear_before(shelter_1.name)
    end

    it 'has a section for shelters with pending applications' do 
      Shelter.destroy_all
      Application.destroy_all
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      pet1 = Pet.create!(adoptable: true, age: 46, breed: 'snapping', name: 'Shelly', shelter_id: shelter_1.id, )
      app1 = Application.create!(name: 'Matt Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "In Progress",  )
      petapplication1 = PetApplication.create!(pet_id: pet1.id, application_id: app1.id)

      visit "/admin/shelters"
     
      within('.pendingshelters') do
        expect(page).to have_content(shelter_1.name)
        expect(page).to_not have_content(shelter_2.name)
        expect(page).to_not have_content(shelter_3.name)
      end
    end
  end
end