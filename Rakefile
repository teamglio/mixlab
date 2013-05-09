desc "Updates the leaderboard"
task :build_leaderboard do
	puts "Building leaderboard..."
	require_relative 'lib/core.rb'
	Leaderboard.build_top_ten
	puts "Done building the leaderboard"
end
