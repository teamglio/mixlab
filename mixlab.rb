#TODO
# secure Mxit app client id and secret

require 'sinatra'
require 'aws-sdk'
require 'rest-client'
require 'json'
require 'rufus-scheduler'
require 'newrelic_rpm'
require_relative 'lib/core.rb'

enable :sessions

configure do
	AWS.config(
	  :access_key_id => ENV['AWS_KEY'],
	  :secret_access_key => ENV['AWS_SECRET']
	)

	#scheduler = Rufus::Scheduler.start_new

	#scheduler.every '15m' do
	#	Leaderboard.build_top_ten
	#end		
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
		session[:element2] = params[:element]

		response =  Composition.mix(Element.all(:name => session[:element1].to_s).first, Element.all(:name => session[:element2].to_s).first)

		unless response.nil?
			@result = "#{session[:element1]} + #{session[:element2]} = <b>#{response.name}</b>"
			@discovery_status = get_discovery_status(response)
			player.elements.push(Element.first(:name => response.name))
			player.save			
			session[:element1] = nil
		else
			@result = session[:element1] + ' + ' + session[:element2] + ' = ' + "<b>nothing</b>"
			session[:element1] = nil
			@discovery_status = "Woops, that doesn't make anything. Try again."
		end
	end
	
	erb :gameboard
end

get '/leaderboard/top_ten' do
	erb :top_ten
end

get '/hint' do
	erb :hint
end

get '/help' do
	erb :help
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
	@players = Player.all
	File.open('public/players.json','w+') do |file|
		file.write(@players.to_json)
	end
	redirect to 'players.json'		
	#erb :players, :layout => nil
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

	def get_discovery_status(element)
		mxit_user = MxitUser.new(request.env)
		player = Player.first(:mxit_user_id => mxit_user.user_id)
		if Discovery.all(:player_id => player.id).elements.first(:name => element.name)
			"You've already discovered #{element.name}..."
		else
			"Well done, you've discovered <b>#{element.name}</b>!"
		end
	end
end