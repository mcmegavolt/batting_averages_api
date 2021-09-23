# frozen_string_literal: true

require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/json'
require 'csv'

set :database, 'sqlite://batting.db'

class Team < Sequel::Model
end
