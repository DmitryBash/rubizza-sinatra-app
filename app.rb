require_relative './config/init'
require 'sinatra'
require_relative './config/environments.rb'

CLIENT_ID = ENV['GITHUB_CLIENT_ID']
CLIENT_SECRET = ENV['GITHUB_SECRET_ID']

set :sessions, true
set :server, :puma

get '/' do
  if current_user
    erb :game
  else
    erb :user_login, :locals => {:client_id => CLIENT_ID}
  end
end

get '/callback' do
  session_code = request.env['rack.request.query_hash']['code']
  result = RestClient.post('https://github.com/login/oauth/access_token',
                          {:client_id => CLIENT_ID,
                           :client_secret => CLIENT_SECRET,
                           :code => session_code},
                           :accept => :json)
  auth_token = {}
  auth_token[:access_token] = JSON.parse(result)['access_token']
  client = get_octokit_user(auth_token[:access_token])
  access_token = generate_user_token(auth_token)
  session[:access_token] = access_token
  create_new_user(client, access_token)
  redirect '/'
end
