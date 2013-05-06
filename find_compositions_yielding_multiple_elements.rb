require_relative 'lib/core.rb'

def mix(element1, element2)
	if Composition.all(primary_element_id: element1.id, secondary_element_id: element2.id)
		Composition.all(primary_element_id: element1.id, secondary_element_id: element2.id).result_element
	elsif Composition.all(primary_element_id: element2.id, secondary_element_id: element1.id)
		Composition.all(primary_element_id: element2.id, secondary_element_id: element1.id).result_element
	else
		nil
	end
end	


Element.all.each do |e|
	Element.all.each do |e2|
		unless mix(e,e2).empty?
			unless mix(e,e2).size <= 1
				puts mix(e,e2).inspect
			end
		end
	end
end


#puts mix(Element.all(:name => 'fire').first,Element.all(:name => 'fire').first).empty?

