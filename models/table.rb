module Models
  class Table < Struct.new(:id, :num_seats, :used_seat)
    def initialize(id, num_seats, used_seat=[]); super end
  end
end
