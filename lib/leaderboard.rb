require 'base64'

class Leaderboard

	attr_reader :leader_board

	def self.top_ten
		player_discoveries = Hash.new
		top_ten = Hash.new
		Player.all.each do |player|
			unless player.discoveries.size  == 4
				player_discoveries[player.mxit_user_id] = player.discoveries.size
			end 
		end
		player_discoveries.sort_by {|key,value| value}.reverse![0..9].each do |key, value|
			top_ten[MxitUserAPI.get_user_profile(key)['DisplayName']] = value
		end
		top_ten
	end
end