class AdminSheltersController < ApplicationController 
  def index 
    @shelters = Shelter.order_by_reverse_alphabetical
    @pending_shelters = Shelter.list_pending
  end

  def show
    @shelter_name_and_city = Shelter.find_shelter_name_city(params[:id]).first
  end
end