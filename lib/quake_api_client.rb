require 'rest-client'
require 'json'

class QuakeApiClient
  attr_accessor :current_game_id, :current_kill_id, :last_kill_id, :kill_count, :comment

  def intialize
  end

  def api_call
    begin
      response = RestClient.get('localhost:3000/kills')
    rescue => e
      return { error: e }
    end

    JSON.parse(response)    
  end
end