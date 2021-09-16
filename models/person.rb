module Models
  class Person < Struct.new(:id, :met_friends)
    def initialize(id, met_friends = []); super end
  end
end
