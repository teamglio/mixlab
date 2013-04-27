class MxitOAuth
	def self.get_access_token
		response = RestClient.post 'https://auth.mxit.com/token','grant_type=client_credentials&scope=profile/public', :content_type => 'application/x-www-form-urlencoded', :authorization => 'Basic ' + Base64.encode64('af5ebe26ccda43a088e1d7168cdac148:c8ac569552a1438fbecbcc64cee869b0').to_s.gsub!("\n","")
		JSON.load(response)['access_token']
	end
end