class MxitUserAPI
	def self.get_user_profile(mxit_user_id)
		response = RestClient.get 'http://api.mxit.com/user/profile/' + mxit_user_id, :grant_type => 'client_credential', :accept => 'application/json', :authorization => 'Bearer ' + MxitOAuth.get_access_token
		JSON.load(response)
	end
end