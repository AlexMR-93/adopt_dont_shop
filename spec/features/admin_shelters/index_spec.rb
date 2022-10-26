require "rails_helper"


RSpec.describe("Admin shelter INDEX Page") do
  before(:each) do
    @shelter1 = Shelter.create(    name: "Als Adoption",     city: "Apple valley CA",     foster_program: false,     rank: 9)
    @shelter3 = Shelter.create(    name: "Calcity Center",     city: "Catalina CA",     foster_program: false,     rank: 9)
    @shelter2 = Shelter.create(    name: "Barstow Building",     city: "Barstow CA",     foster_program: false,     rank: 9)
    @smithers_application = Application.create!(    name: "Smithers",     street_address: "99 Higgins Estate",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "I have a lot of land and no friends",     status: "Pending")
    @homer_application = Application.create!(    name: "Homer",     street_address: "24 East Ridge",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "since the drinking hole closed i have a lot of time on my hands and no friends",     status: "In Progress")
    @scooby = @shelter1.pets.create(    name: "Scooby",     age: 2,     breed: "Great Dane",     adoptable: true,     shelter_id: @shelter1.id)
    @bolt = @shelter1.pets.create(    name: "Bolt",     age: 1,     breed: "Chihuahua",     adoptable: true,     shelter_id: @shelter2.id)
    @pet_app_1 = PetApplication.create!(    pet: @bolt,     application: @smithers_application)
  end

  it("I see all Shelters in the system listed in reverse alphabetical order by name") do
    visit("/admin/shelters")
    expect(@shelter3.name).to(appear_before(@shelter2.name))
    expect(@shelter1.name).to_not(appear_before(@shelter2.name))
  end

  it("#11. Then I see a section for Shelter's with Pending Applications
And in this section I see the name of every shelter that has a pending application") do
    visit("/admin/shelters")
    expect(page).to(have_content("Shelters with Pending Applications:#{@shelter1.name}"))
  end
end
