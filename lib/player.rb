require 'data_mapper'

class Player
	include DataMapper::Resource

	property :id, Serial
	property :mxit_user_id, String
	property :number_of_discoveries, Integer

	has n, :discoveries
	has n, :elements, :through => :discoveries
end