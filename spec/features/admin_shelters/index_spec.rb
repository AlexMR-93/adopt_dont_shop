require "rails_helper"


RSpec.describe("Admin shelter INDEX Page") do
  before(:each) do
    @shelter1 = Shelter.create(    name: "Als Adoption",     city: "Apple valley CA",     foster_program: false,     rank: 9)
    @shelter3 = Shelter.create(    name: "Calcity Center",     city: "Catalina CA",     foster_program: false,     rank: 9)
    @shelter2 = Shelter.create(    name: "Barstow Building",     city: "Barstow CA",     foster_program: false,     rank: 9)
  end

  it("I see all Shelters in the system listed in reverse alphabetical order by name") do
    visit("/admin/shelters")
    save_and_open_page
    expect(@shelter3.name).to(appear_before(@shelter2.name))
    expect(@shelter1.name).to_not(appear_before(@shelter2.name))
  end
end
