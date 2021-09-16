require './models/person'
require './models/table'
require './presenters/dinner_friends_presenter'

module Services
  class DinnerPlanner
    CandidateTable = Struct.new(:table_id, :score)

    def initialize(people_count = 30,num_tables = 5, num_seats = 6, courses = 3)
      @people = create_people(people_count)
      @tables = create_tables(num_tables, num_seats)
      @courses = courses
    end

    def call
      return 'there is no courses' if @courses == 0

      @courses.times do |course|
        ordered_people(course).each do |person|
          set_person_in_table(person)
        end
        @tables.each do |table|
          table.used_seat.each do |person_id|
            save_person_friends_history(person_id, table)
          end

          prepare_table_for_new_course(table)
        end
      end
      Presenters::DinnerFriendsPresenter.new(@people).call
    end

    private

    def create_people(people_count)
      (1...people_count).map { |i| Models::Person.new(i) }
    end

    def create_tables(num_tables, num_seats)
      (1..num_tables).map { |i| Models::Table.new(i, num_seats) }
    end

    def ordered_people(course)
      return @people if course == 0
      @people.sort_by { |person| person.met_friends.size }
    end

    def set_person_in_table(person)
      best_table = find_best_table(person)
      best_table.used_seat << person.id
    end

    def find_best_table(person)
      candidates = []
      @tables.each do |table|
        next if table.used_seat.size == table.num_seats

        score = (person.met_friends & table.used_seat).size
        candidates << CandidateTable.new(table.id, score)
      end

      @tables.select { |table| table.id == candidates.min_by { |candidate| candidate.score }.table_id }.first
    end

    def save_person_friends_history( person_id, table)
      person = @people.select{ |person| person.id == person_id}.first
      person.met_friends.concat(table.used_seat.reject {|val| val == person_id })
      person.met_friends.uniq!
    end

    def prepare_table_for_new_course(table)
      table.used_seat = []
    end
  end
end



