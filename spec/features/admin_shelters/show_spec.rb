require 'rails_helper'

RSpec.describe "Admin Shelters Show" do 
  describe 'When visiting admin shelters show (/admin/shelters/:id)' do
    it 'shows the shelter name and address' do
      Shelter.destroy_all
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

      visit "admin/shelters/#{shelter_1.id}"
   
      expect(page).to have_content("Name: #{shelter_1.name}")
      expect(page).to have_content("City: #{shelter_1.city}")
    end
  end
end   