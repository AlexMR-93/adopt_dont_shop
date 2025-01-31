class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end

  def show
    @application = Application.find(params[:id])

    if params[:pet_name].present?
      @pets = Pet.search(params[:pet_name])
    elsif params[:pet_id]
      pet = Pet.where(      id: params[:pet_id])
      @application.pets << pet
      @pets = @application.pets
      redirect_to("/applications/#{@application.id}")
    else
      @pets = []
    end
  end

  def new
  end

  def create
    new_app = Application.new(    name: params[:name],     street_address: params[:street_address],     city: params[:city],     state: params[:state],     zip_code: params[:zip_code],     description: params[:description],     status: "In Progress")

    if new_app.valid?
      new_app.update(      status: "In Progress")
      redirect_to("/applications/#{new_app.id}")
    else
      flash[:notice] = "Error: #{error_message(new_app.errors)}"
      redirect_to("/applications/new")
    end
  end

  def update
    application = Application.find(params[:id])

    if application.update(    description: params[:description],     status: "Pending")
      redirect_to("/applications/#{application.id}")
    else
      redirect_to("/applications/#{application.id}")
      flash[:alert] = "Error: #{error_message(application.errors)}"
    end
  end

  private

  def app_params
    params.permit(:name, :street_address, :city, :state, :zip_code)
  end
end
