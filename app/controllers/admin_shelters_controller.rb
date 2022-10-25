class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.alpha_organize
  end
end
