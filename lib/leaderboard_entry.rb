require 'data_mapper'

class LeaderboardEntry
	include DataMapper::Resource

	property :id, Serial
	property :nickname, Text	
	property :discoveries, Integer

end