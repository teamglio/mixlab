require 'data_mapper'

class Discovery
	include DataMapper::Resource

	belongs_to :player, :key => true
	belongs_to :element, :key => true
end