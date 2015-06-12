require "rails_helper"

describe User do
  it { should have_many(:pets).dependent(:destroy) }
  it { should validate_presence_of(:first_name) }

  describe "#full_name" do
    it "returns title cased first and last names" do
      user = User.new(first_name: "homer", last_name: "simpson")

      expect(user.full_name).to eq "Homer Simpson"
    end

    it "returns only first_name if no last_name" do
      user = User.new(first_name: "homer")

      expect(user.full_name).to eq "Homer"
    end
  end
end
