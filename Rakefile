require_relative 'mixlab.rb'

desc "Updates the leaderboard"
task :build_leaderboard do
	puts "Building leaderboard..."
	require_relative 'lib/core.rb'
	Leaderboard.build_top_ten
	puts "Done building the leaderboard"
end

desc "Migrate user data to Firebase"
task :migrate_users_to_firebase do
	Firebase.base_uri = "https://glio-mxit-users.firebaseio.com/mixlab"
	puts "Starting..."
	Player.all.each do |user|
		Firebase.set(user.mxit_user_id,{:date_joined => user.date_joined})
	end
	puts "Done"
end