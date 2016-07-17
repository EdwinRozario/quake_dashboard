quake_api = QuakeApiClient.new

SCHEDULER.every '3s' do
  quake_api.next_kill
  
  send_event('game', { text: quake_api.game })
  send_event('comments', { text: quake_api.comment })
  send_event('kill_count', { current: quake_api.kill_count, last: quake_api.kill_count - 1 })
  send_event('kills',   { items: quake_api.kill_by_players })
end
