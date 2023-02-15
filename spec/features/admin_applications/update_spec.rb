require 'rails_helper'

RSpec.describe 'Admin Applications Show Page' do 
  Shelter.destroy_all 
  Application.destroy_all 
  Pet.destroy_all 
  PetApplication.destroy_all
 
  describe 'When visiting admin application show page (/admin/applications/:id)' do 
    describe 'after approving all individual pets the applications status' do
       it 'shows as accepted' do
          shelter1 = Shelter.create!(foster_program: true, name: 'Pet Friends', city: "Denver", rank: 3)
          app1 = Application.create!(name: 'Matt Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "In Progress",)
          app2 = Application.create!(name: 'Timothy Timoth', street_address: "666 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "In Progress",)
          pet1 = Pet.create!(adoptable: true, age: 46, breed: 'snapping', name: 'Shelly', shelter_id: shelter1.id, )
          pet2 = Pet.create!(adoptable: true, age: 2, breed: 'husky', name: 'Benedict McBark', shelter_id: shelter1.id,)
          pet3 = Pet.create!(adoptable: true, age: 2, breed: 'husky', name: 'Gabe', shelter_id: shelter1.id,)
          petapplication1 = PetApplication.create!(pet_id: pet1.id, application_id: app1.id, status: "In Progress")
          petapplication2 = PetApplication.create!(pet_id: pet2.id, application_id: app1.id, status: "In Progress")
          petapplication3 = PetApplication.create!(pet_id: pet3.id, application_id: app1.id, status: "In Progress")
          petapplication4 = PetApplication.create!(pet_id: pet2.id, application_id: app2.id, status: "In Progress")

          visit "/admin/applications/#{app1.id}"
          
          click_button("Approve #{pet1.name}")
          click_button("Approve #{pet2.name}")
          click_button("Approve #{pet3.name}")
        
          expect(current_path).to eq("/admin/applications/#{app1.id}")
          expect(page).to have_content("Application Status: Accepted")

        end
    end

    describe 'rejecting at least one pet and rejecting/approving the remaining pets' do
      it 'shows as rejected' do
         shelter1 = Shelter.create!(foster_program: true, name: 'Pet Friends', city: "Denver", rank: 3)
         app1 = Application.create!(name: 'Matt Smith', street_address: "1101 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "In Progress",)
         app2 = Application.create!(name: 'Timothy Timoth', street_address: "666 Main", city: "Denver", state: "CO", zipcode: 55555, description: "I like turtles!", status: "In Progress",)
         pet1 = Pet.create!(adoptable: true, age: 46, breed: 'snapping', name: 'Shelly', shelter_id: shelter1.id, )
         pet2 = Pet.create!(adoptable: true, age: 2, breed: 'husky', name: 'Benedict McBark', shelter_id: shelter1.id,)
         pet3 = Pet.create!(adoptable: true, age: 2, breed: 'husky', name: 'Gabe', shelter_id: shelter1.id,)
         petapplication1 = PetApplication.create!(pet_id: pet1.id, application_id: app1.id, status: "In Progress")
         petapplication2 = PetApplication.create!(pet_id: pet2.id, application_id: app1.id, status: "In Progress")
         petapplication3 = PetApplication.create!(pet_id: pet3.id, application_id: app1.id, status: "In Progress")
         petapplication4 = PetApplication.create!(pet_id: pet2.id, application_id: app2.id, status: "In Progress")

         visit "/admin/applications/#{app1.id}"
         first(:button,"Reject this pet for adoption").click

         click_button("Approve #{pet2.name}")
         click_button("Approve #{pet3.name}")
       
         expect(current_path).to eq("/admin/applications/#{app1.id}")
         expect(page).to have_content("Application Status: Rejected")
       end
   end
  end
end      
          
