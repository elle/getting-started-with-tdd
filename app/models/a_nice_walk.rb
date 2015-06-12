class ANiceWalk
  def self.for(person)
    raise CantWalkWithoutPets if person.pets.empty?
    person.update(happiness: 20)
  end
end

class CantWalkWithoutPets < StandardError; end
