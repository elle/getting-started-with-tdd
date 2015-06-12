require_relative "../../app/models/a_nice_walk"

describe ANiceWalk do
  context "without a pet" do
    it "is impossible" do
      alice = double(pets: [])

      expect do
        ANiceWalk.for(alice)
      end.to raise_error CantWalkWithoutPets
    end
  end

  context "with a pet" do
    it "does not raise an error" do
      alice = double(pets: [double])
      allow(alice).to receive(:update)

      expect do
        ANiceWalk.for(alice)
      end.not_to raise_error
    end

    it "makes the walker happy" do
      alice = double(pets: [double])
      allow(alice).to receive(:update)

      ANiceWalk.for(alice)

      expect(alice).to have_received(:update).with(happiness: 20)
    end
  end
end
