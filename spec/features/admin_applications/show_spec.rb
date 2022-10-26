require "rails_helper"


RSpec.describe("Admin Application Show Page") do
  before(:each) do
    @shelter1 = Shelter.create(    name: "Als Adoption",     city: "Apple valley CA",     foster_program: false,     rank: 9)
    @shelter3 = Shelter.create(    name: "Calcity Center",     city: "Catalina CA",     foster_program: false,     rank: 9)
    @shelter2 = Shelter.create(    name: "Barstow Building",     city: "Barstow CA",     foster_program: false,     rank: 9)
    @smithers_application = Application.create!(    name: "Smithers",     street_address: "99 Higgins Estate",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "I have a lot of land and no friends",     status: "Pending")
    @homer_application = Application.create!(    name: "Homer",     street_address: "24 East Ridge",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "since the drinking hole closed i have a lot of time on my hands and no friends",     status: "In Progress")
    @scooby = @shelter1.pets.create(    name: "Scooby",     age: 2,     breed: "Great Dane",     adoptable: true,     shelter_id: @shelter1.id)
    @bolt = @shelter1.pets.create(    name: "Bolt",     age: 1,     breed: "Chihuahua",     adoptable: true,     shelter_id: @shelter2.id)
    @pet_app_1 = PetApplication.create!(    pet: @bolt,     application: @smithers_application)
    @pet_app_2 = PetApplication.create!(    pet: @scooby,     application: @smithers_application)
  end

  describe("For every pet that the application is for, I see a button to approve the application for that specific pet") do
    describe("click that button Then I'm taken back to the admin application show page") do
      describe(" next to the pet that I approved, I do not see a button to approve this pet") do
        it("#12.instead I see an indicator next to the pet that they have been approved") do
          visit("/admin/applications/#{@smithers_application.id}")
          save_and_open_page
          expect(page).to(have_button("Approve #{@bolt.name} for #{@smithers_application.name}"))
          within("#pets-#{@bolt.id}")
          click_button("Approve #{@bolt.name} for #{@smithers_application.name}")
          expect(current_path).to(eq("/admin/applications/#{@smithers_application.id}"))
          expect(page).to(have_content("Application Status: Approved"))
        end
      end
    end
  end

  describe("For every pet that the application is for, I see a button to Reject the application for that specific pet") do
    describe("click that button Then I'm taken back to the admin application show page") do
      describe(" next to the pet that I Rejected, I do not see a button to approve this pet") do
        it("#13.instead I see an indicator next to the pet that they have been Rejected") do
          visit("/admin/applications/#{@smithers_application.id}")
          save_and_open_page
          expect(page).to(have_button("Approve #{@bolt.name} for #{@smithers_application.name}"))
          within("#pets-#{@bolt.id}")
          click_button("Reject #{@bolt.name} for #{@smithers_application.name}")
          expect(current_path).to(eq("/admin/applications/#{@smithers_application.id}"))
          expect(page).to(have_content("Application Status: Rejected"))
        end
      end
    end
  end
end
