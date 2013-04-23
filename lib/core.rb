require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'])

require_relative 'element'
require_relative 'composition'
require_relative 'data'
require_relative 'player'
require_relative 'discovery'
require_relative 'mxit_user'

DataMapper.finalize