require_relative 'element.rb'
require_relative 'composition.rb'
require 'data_mapper'
require 'csv'

class Data

	def self.rebuild_data
		start_time = Time.now
		DataMapper.auto_migrate!

		CSV.foreach('data/la.csv', :headers => true) do |r|
			e = Element.create(:name => r['element name'])
			e.save
		end

		CSV.foreach('data/la.csv', :headers => true) do |r|
			c = Composition.create(:primary_element => Element.all(:name => r['element a1 name']).first, :secondary_element => Element.all(:name => r['element a2 name']).first, :result_element => Element.all(:name => r['element name']).first)
			c.save

			unless r['element b1 name'].nil?
				c = Composition.create(:primary_element => Element.all(:name => r['element b1 name']).first, :secondary_element => Element.all(:name => r['element b2 name']).first, :result_element => Element.all(:name => r['element name']).first)
				c.save
			end

			unless r['element c1 name'].nil?
				c = Composition.create(:primary_element => Element.all(:name => r['element c1 name']).first, :secondary_element => Element.all(:name => r['element c2 name']).first, :result_element => Element.all(:name => r['element name']).first)
				c.save
			end	

			unless r['element d1 name'].nil?
				c = Composition.create(:primary_element => Element.all(:name => r['element d1 name']).first, :secondary_element => Element.all(:name => r['element d2 name']).first, :result_element => Element.all(:name => r['element name']).first)
				c.save
			end				
		end

		end_time = Time.now

		puts "Database was rebuilt in #{end_time.sec - start_time.sec} seconds."
	end
end