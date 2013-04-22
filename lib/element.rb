require 'data_mapper'

class Element
	include DataMapper::Resource

	property :id, Serial
	property :name, String 
end