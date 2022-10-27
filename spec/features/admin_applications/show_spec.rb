require "rails_helper"


RSpec.describe("Admin Application Show Page") do
  before(:each) do
    @shelter1 = Shelter.create(    name: "Als Adoption",     city: "Apple valley CA",     foster_program: false,     rank: 9)
    @shelter3 = Shelter.create(    name: "Calcity Center",     city: "Catalina CA",     foster_program: false,     rank: 9)
    @shelter2 = Shelter.create(    name: "Barstow Building",     city: "Barstow CA",     foster_program: false,     rank: 9)
    @aurora = Shelter.create!(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    
    @smithers_application = Application.create!(    name: "Smithers",     street_address: "99 Higgins Estate",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "I have a lot of land and no friends",     status: "Pending")
    @homer_application = Application.create!(    name: "Homer",     street_address: "24 East Ridge",     city: "Springfield",     state: "IL",     zip_code: 90597,     description: "since the drinking hole closed i have a lot of time on my hands and no friends",     status: "In Progress")
    @joe_application = Application.create!(name: "Joe", street_address: "2 Middle Ridge", city: "Marwin", state: "IL", zip_code: 90597, description: "love dogs no friends", status: "In Progress")

    @scooby = @shelter1.pets.create(    name: "Scooby",     age: 2,     breed: "Great Dane",     adoptable: true,     shelter_id: @shelter1.id)
    @bolt = @shelter1.pets.create(    name: "Bolt",     age: 1,     breed: "Chihuahua",     adoptable: true,     shelter_id: @shelter2.id)
    @bare_y = Pet.create!(adoptable: true, age: 7, breed: 'sphynx', name: 'Bare-y Manilow', shelter_id: @aurora.id)
    @babe = Pet.create!(adoptable: true, age: 3, breed: 'domestic pig', name: 'Babe', shelter_id: @aurora.id)

    @pet_app_1 = PetApplication.create!(    pet: @bolt,       application: @smithers_application)
    @pet_app_2 = PetApplication.create!(    pet: @scooby,     application: @smithers_application)
    @pet_app_3 = PetApplication.create!(    pet: @scooby,     application: @homer_application)
    @pet_app_4 = PetApplication.create!(    pet: @bare_y,     application: @homer_application)
    @pet_app_5 = PetApplication.create!(    pet: @babe,       application: @smithers_application)
    @pet_app_6 = PetApplication.create!(    pet: @scooby,     application: @joe_application)
  end

  describe("For every pet that the application is for, I see a button to approve the application for that specific pet") do
    describe("click that button Then I'm taken back to the admin application show page") do
      describe(" next to the pet that I approved, I do not see a button to approve this pet") do
        it("#12.instead I see an indicator next to the pet that they have been approved") do
          visit("/admin/applications/#{@smithers_application.id}")
          # save_and_open_page
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
          # save_and_open_page
          expect(page).to(have_button("Approve #{@bolt.name} for #{@smithers_application.name}"))
          within("#pets-#{@bolt.id}")
          click_button("Reject #{@bolt.name} for #{@smithers_application.name}")
          expect(current_path).to(eq("/admin/applications/#{@smithers_application.id}"))
          expect(page).to(have_content("Application Status: Rejected"))
        end
      end
    end
  end

  describe "When there are two applications in the system for the same pet" do
    describe "When I visit the admin application show page for one of the applications" do
      describe "And I approve or reject the pet for that application" do
        it "does not display that the pet has been accepted or rejected for that application" do
          visit("/admin/applications/#{@smithers_application.id}")
          within("#pets-#{@scooby.id}")
          click_button("Reject #{@scooby.name} for #{@smithers_application.name}")
          
          visit("/admin/applications/#{@homer_application.id}")
          # save_and_open_page
          expect(page).to(have_button("Approve #{@scooby.name} for #{@homer_application.name}"))
          within("#pets-#{@scooby.id}")
          click_button("Reject #{@scooby.name} for #{@homer_application.name}")
        end
        
        it "displays a buttons to approve or reject the pet for the other application" do
          visit("/admin/applications/#{@homer_application.id}")
          expect(page).to(have_button("Approve #{@scooby.name} for #{@homer_application.name}"))
          within("#pets-#{@scooby.id}")
          click_button("Reject #{@scooby.name} for #{@homer_application.name}")
        end
      end
    end
  end

  describe "all pets accepted on app - When I visit an admin application show page" do
    describe "And I approve all pets for an application" do
      describe "Then I am taken back to the admin application show page" do
        it "displays the application's status has changed to 'Approved' " do
          visit("/admin/applications/#{@smithers_application.id}")
          
          expect(page).not_to(have_button("Approve #{@bare_y.name} for #{@smithers_application.name}"))
          click_button("Approve #{@bolt.name} for #{@smithers_application.name}")
          click_button("Approve #{@scooby.name} for #{@smithers_application.name}")
          click_button("Approve #{@babe.name} for #{@smithers_application.name}")
          expect(current_path).to(eq("/admin/applications/#{@smithers_application.id}"))
          expect(page).to(have_content("Application Status: Approved"))
          # save_and_open_page
        end
      end
    end
  end

  describe "When I visit an admin application show page" do
    describe "And I reject one or more pets for the application" do
      describe "And I approve all other pets on the application" do
        describe "Then I am taken back to the admin application show page" do
          it "And I see the application's status has changed to 'Rejected'" do
            visit("/admin/applications/#{@smithers_application.id}")
          
            expect(page).not_to(have_button("Approve #{@bare_y.name} for #{@smithers_application.name}"))
            click_button("Approve #{@bolt.name} for #{@smithers_application.name}")
            click_button("Approve #{@babe.name} for #{@smithers_application.name}")
            click_button("Reject #{@scooby.name} for #{@smithers_application.name}")
            # save_and_open_page
            expect(current_path).to(eq("/admin/applications/#{@smithers_application.id}"))
            expect(page).to(have_content("Application Status: Rejected"))
          end
        end
      end
    end
  end


end