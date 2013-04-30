class Hint
	def self.get
		random_composition = Composition.get(rand(1..Composition.all.size))
		"#{Element.get(random_composition.primary_element_id).name} + #{Element.get(random_composition.secondary_element_id).name} = #{Element.get(random_composition.result_element_id).name}"
	end
end
