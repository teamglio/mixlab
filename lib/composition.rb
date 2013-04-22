require 'data_mapper'

class Composition
	include DataMapper::Resource

	property :id, Serial
	belongs_to :primary_element, 'Element'
	belongs_to :secondary_element, 'Element'
	belongs_to :result_element, 'Element'

	def self.mix(element1, element2)
		if first(primary_element_id: element1.id, secondary_element_id: element2.id)
			first(primary_element_id: element1.id, secondary_element_id: element2.id).result_element
		elsif first(primary_element_id: element2.id, secondary_element_id: element1.id)
			first(primary_element_id: element2.id, secondary_element_id: element1.id).result_element
		else
			nil
		end
	end
end