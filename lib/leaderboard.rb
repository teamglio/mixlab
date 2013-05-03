require 'base64'

class Leaderboard

	def self.build_top_ten
		
		LeaderboardEntry.all.destroy

		player_discoveries = Hash.new
		Player.all.each do |player|
			unless player.discoveries.size  == 4
				player_discoveries[player.mxit_user_id] = player.discoveries.size
			end 
		end

		player_discoveries.sort_by {|key,value| value}.reverse![0..9].each do |key, value|
			user_profile = MxitUserAPI.get_user_profile(key)
			if user_profile 
				LeaderboardEntry.create(:nickname => user_profile['DisplayName'], :discoveries => value)
			end
		end

	end

	def self.top_ten
		LeaderboardEntry.all
	end	
end