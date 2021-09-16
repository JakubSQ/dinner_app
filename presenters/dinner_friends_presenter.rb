module Presenters
  class DinnerFriendsPresenter

    def initialize(people)
      @people = people
    end

    def call
      puts '####################################'
      puts 'People connections:'
      print_friends
      puts '####################################'
      puts 'Social contacts by numbers:'
      print_social_contacts
      puts '####################################'
    end

    def print_friends
      @people.each do |person|
        puts "person with an id: #{person.id} will meet with people with ids: #{person.met_friends}"
      end
    end

    def print_social_contacts
      @people.group_by { |person| person.met_friends.size }.sort_by { |k, v| k }.each do |social_contacts|
      puts "#{social_contacts[0]} people will be met by people with ids: #{social_contact_ids(social_contacts) }"
      end
    end

    private

    def social_contact_ids(social_contacts)
      social_contacts[1].map { |social_contact| social_contact.id }
    end
  end
end
