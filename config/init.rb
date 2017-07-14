require 'sinatra/activerecord'
require 'rest-client'
require 'json'
require 'octokit'
require 'jwt'
require 'dotenv/load'

skip_dir_names = ['.', '..']

load_path = ['./app/models/']

load_path.each do |path|
  Dir.foreach(path) do |file_name|
    next if skip_dir_names.include?(file_name)
    require path + file_name
  end
end
