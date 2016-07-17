SCHEDULER.every '2s' do  
  send_event('game', { text: "Cant connect to Quake Api" })
  send_event('comments', { text: comment })
  send_event('kill_count', { current: current_karma, last: last_karma })
  send_event('kills',   { items: rand(100) })
end
