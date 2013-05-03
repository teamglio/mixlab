require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'])
#DataMapper.setup(:default, 'postgres://postgres:paashaas@localhost/mixlab')


require_relative 'element'
require_relative 'composition'
require_relative 'data'
require_relative 'player'
require_relative 'discovery'
require_relative 'mxit_user'
require_relative 'leaderboard'
require_relative 'leaderboard_entry'
require_relative 'hint'
require_relative 'mxit_oauth'
require_relative 'mxit_user_api'

DataMapper.finalize
DataMapper.auto_upgrade!