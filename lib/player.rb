require 'data_mapper'

class Player
	include DataMapper::Resource

	property :id, Serial
	property :mxit_user_id, String

	has n, :discoveries
	has n, :elements, :through => :discoveries
end