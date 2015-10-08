require 'time_diff'

oba_communicator = OBACommunicator.new


targets = [
  {stop_no: 621, routes: ['71', '71E', '72', '72E', '73', '73E', '74']},
]

SCHEDULER.every '30m', :first_in => 0 do |job|
  data = {}
  targets.each do |target|
    response_obj = JSON.parse(oba_communicator.getArrivalsAtStop(target[:stop_no]))
    entries = response_obj['data']['entry']['arrivalsAndDepartures']

    reported_routes = []
    entries.each do |entry|
    route = entry['routeShortName']
    if target[:routes].include?(route)
      routeinfo = RouteInfoFactory.new(entry)
      reported_routes << routeinfo.getInfo
      end
    end

    target_stop = target[:stop_no]
    data[target_stop] = reported_routes
  end

  puts '-----------------------'
  puts data;
  puts '-----------------------'

  send_event('onebusaway', { targets: data })
end


class ETACreator

end
