# frozen_string_literal: true

require './application'
require './services/batting_service'
require 'csv'

module App
  class BattingAvg < Sinatra::Base
    post '/calculate' do
      begin
        file_path = params[:file][:tempfile].to_path
        players_data = CSV.open(file_path, headers: :first_row).map(&:to_h)
        result = BattingService.call(players_data, params[:filter_by] || {})

        json result
      rescue StandardError => e
        json errors: e.message, backtrace: e.backtrace
      end
    end
  end
end
