require 'rest-client'
require 'json'

class QuakeApiClient
  attr_accessor :current_game_id, :current_kill_id, :last_kill_id, :kill_count, :comment, :game, :kill_by_players, :player_kills

  def initialize
    initials = api_call('localhost:3000/kills')
    if initials
      @current_kill_id, @last_kill_id = (initials['first_id'] - 1), initials['last_id']
    else
      @current_kill_id = 0
    end

    @kill_by_players = []
    @player_kills = {}
    @kill_count = 0
  end

  def next_kill
    if @current_kill_id > @last_kill_id
      @comment = "Logs have ended"
      @game = "No Game"
    else
      response = api_call("localhost:3000/kills/#{@current_kill_id + 1}/details")

      p "----------------------------------------------------------------"
      p "response: #{response}"

      if @current_game_id != response['game_id']
        reset_all
      end
      @current_game_id = response['game_id']
      @current_kill_id += 1
      @kill_count += 1 
      @game = "Game #{response['game_id']}"

      if response['killer'] == '<world>'
        @comment = "#{response['victim']} got killed by #{response['method']}"
      else
        
        if @player_kills.has_key?(response['killer'])
          @player_kills[response['killer']][:kills] += 1
        else
          @player_kills[response['killer']] = { kills: 1, deaths: 0 }
        end

        @comment = "#{response['killer']} killed #{response['victim']} with #{response['method']}"      
      end


      if @player_kills.has_key?(response['victim'])
        @player_kills[response['victim']][:deaths] += 1
      else
        @player_kills[response['victim']] = { kills: 0, deaths: 1 }
      end


      make_kill_by_players
    end
  end

  def make_kill_by_players
    @kill_by_players = []
    @player_kills.each do |player, values|
      @kill_by_players << { label: player, value: "#{values[:kills]}/#{values[:deaths]}" }
    end
  end

  def reset_all
    @kill_by_players = []
    @player_kills = {}
    @kill_count = 0    
  end

  def api_call(url)
    begin
      response = RestClient.get(url)
    rescue => e
      @comment = "Cant connect to Quake Api"
      @game = "Cant connect to Quake Api"
      return nil
    end

    JSON.parse(response)    
  end
end