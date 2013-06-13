class MxitUserAPI
	def self.get_user_profile(mxit_user_id)
		response = RestClient.get 'http://api.mxit.com/user/profile/' + mxit_user_id, :accept => 'application/json', :authorization => 'Bearer ' + MxitOAuth.get_access_token do |response, request, result|
			case response.code
			when 200
				JSON.load(response)
			else
				nil
			end
		end
	end
end