require 'data_mapper'

#DataMapper.setup(:default, "yaml:db")
#DataMapper.setup(:default, "sqlite:///home/emile/Dropbox/Projects/Mxit/Code/mixlab/db/ml.db")
#DataMapper.setup(:default, 'postgres://postgres:paashaas@localhost/mixlab')
DataMapper.setup(:default, ENV['DATABASE_URL'])

require_relative 'element'
require_relative 'composition'
require_relative 'data'
require_relative 'player'
require_relative 'discovery'
require_relative 'mxit_user'

DataMapper.finalize