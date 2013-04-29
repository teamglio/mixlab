require 'base64'

class Leaderboard

	def self.build_top_ten
		player_discoveries = Hash.new
		top_ten = Hash.new
		Player.all.each do |player|
			unless player.discoveries.size  == 4
				player_discoveries[player.mxit_user_id] = player.discoveries.size
			end 
		end
		player_discoveries.sort_by {|key,value| value}.reverse![0..9].each do |key, value|
			user_profile = MxitUserAPI.get_user_profile(key)
			if user_profile 
				top_ten[user_profile['DisplayName']] = value
			end
		end

		File.open('public/leaderboard_top_ten.json','w+') do |file|
			file.write(top_ten.to_json)
		end	
	end

	def self.top_ten
		JSON.load(File.open('public/leaderboard_top_ten.json','r'))
	end
end