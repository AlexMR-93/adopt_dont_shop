require "rails_helper"


RSpec.describe(AdminShelter) do
  before(:each) do
    @shelter1 = Shelter.create(    name: "Als Adoption",     city: "Apple valley CA",     foster_program: false,     rank: 9)
    @shelter3 = Shelter.create(    name: "Calcity Center",     city: "Catalina CA",     foster_program: false,     rank: 9)
    @shelter2 = Shelter.create(    name: "Barstow Building",     city: "Barstow CA",     foster_program: false,     rank: 9)
  end

  describe("class methods") do
    describe("#alpha_organize") do
      it("returns alphabetical order") do
        expect(Shelter.alpha_organize).to(eq([@shelter3, @shelter2, @shelter1]))
      end
    end
  end
end
