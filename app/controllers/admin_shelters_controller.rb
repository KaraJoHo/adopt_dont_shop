class AdminSheltersController < ApplicationController 
  def index 
    @shelters = Shelter.order_by_reverse_alphabetical
    @pending_shelters = Shelter.order_by_alphabetical_pending
  end
end