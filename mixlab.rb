#TODO
# secure Mxit app client id and secret

require 'sinatra'
require_relative 'lib/core.rb'

enable :sessions

configure do
	AWS.config(
	  :access_key_id => ENV['AWS_KEY'],
	  :secret_access_key => ENV['AWS_SECRET']
	)		
end

before do
	@mixup_ad = RestClient.get 'http://serve.mixup.hapnic.com/10230670'
end

get '/' do
	redirect to '/game'
end

get '/game' do
	player = get_player

	if player.nil?
		mxit_user = MxitUser.new(request.env)
		player = Player.create(:mxit_user_id => mxit_user.user_id)
		player.elements.push(Element.first(:name => 'water'),Element.first(:name => 'fire'),Element.first(:name => 'earth'),Element.first(:name => 'air'))
		player.save
		erb :help
	else
		erb :gameboard	
	end
end

get '/game/:element' do

	player = get_player
	
	if session[:element1].nil?
		session[:element1] = params[:element]
		@result = session[:element1] + ' + '
	else
		session[:element2] = nil
		session[:element2] = params[:element]

		response =  Composition.mix(Element.first(:name => session[:element1].to_s), Element.first(:name => session[:element2].to_s))

		unless response.nil?
			if response.size == 1
				@discovery_status = get_discovery_status(response)
				element = response.first
				@result = "#{session[:element1]} + #{session[:element2]} = "
				@result += "<b>#{element.name}</b>"
				player.elements.push(Element.first(:name => element.name))

				
			else
				@discovery_status = get_discovery_status(response)				
				@result = "#{session[:element1]} + #{session[:element2]} = "
				response.each do |element|
					unless response.index(element) == response.index(response.last)
						@result += "<b>#{element.name}</b>" + " & " 
					else
						@result += "<b>#{element.name}</b>"
					end
					player.elements.push(Element.first(:name => element.name))				
				end
			end
			session[:element1] = nil
		else
			@result = session[:element1] + ' + ' + session[:element2] + ' = ' + "<b>nothing</b>"
			session[:element1] = nil
			@discovery_status = "Woops, that doesn't make anything. Try again."
		end
	end
	player.number_of_discoveries = player.discoveries.size	
	player.save	
	erb :gameboard
end

get '/leaderboard/top_ten' do
	erb :top_ten
end

get '/account' do
	erb :account
end

get '/hint' do
	erb :hint
end

get '/news' do
	erb :news
end

get '/reset?' do
	erb "Are you sure you want to reset your game? <b>You will lose all your discoveries!</b><br /><a href='/reset!'>Yes</a> | <a href='/game'>No way</a>"
end

get '/reset!' do
	player = get_player
	player.discoveries.destroy
	player.elements.push(Element.first(:name => 'water'),Element.first(:name => 'fire'),Element.first(:name => 'earth'),Element.first(:name => 'air'))	
	player.save
	erb "Game reset! <a href='/game'>Play again</a>."
end

get '/feedback' do
	erb :feedback
end

post '/feedback' do
	player = get_player
	ses = AWS::SimpleEmailService.new
	ses.send_email(
	  :subject => 'MixLab feedback',
	  :from => 'emile@silvis.co.za',
	  :to => 'emile@silvis.co.za',
	  :body_text => params['feedback'] + ' - ' + player.mxit_user_id
	  )
	erb "Thanks! <a href='/'>Back</a>" 
end

get '/players' do
	content_type :json 
	{:number_of_players => Player.all.size}.to_json
end

helpers do
	def discoveries
		mxit_user = MxitUser.new(request.env)
		player = Player.first(:mxit_user_id => mxit_user.user_id)
		Discovery.all(:player_id => player.id)
	end

	def get_player
		mxit_user = MxitUser.new(request.env)
		Player.first(:mxit_user_id => mxit_user.user_id)
	end

	def get_discovery_status(response)
		mxit_user = MxitUser.new(request.env)
		player = Player.first(:mxit_user_id => mxit_user.user_id)
		if Discovery.all(:player_id => player.id).elements.first(:name => response.first.name)
			"You've <b style='color:#FF9933;'>already discovered</b> this combination..."
		else
			"Well done, you've discovered a <b style='color:#339900;'>new combination</b>!"
		end				
	end
end