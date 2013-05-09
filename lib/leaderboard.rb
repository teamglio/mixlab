require 'base64'

class Leaderboard


	def self.build_top_ten
		
		LeaderboardEntry.all.destroy

		Player.all(:number_of_discoveries.gt => 4).all(:order => [:number_of_discoveries.desc])[0..9].each do |player|
			user_profile = MxitUserAPI.get_user_profile(player.mxit_user_id)
			if user_profile
				LeaderboardEntry.create(:nickname => user_profile['DisplayName'], :discoveries => player.number_of_discoveries)
			end
		end
	end

	def self.top_ten
		LeaderboardEntry.all
	end	
end