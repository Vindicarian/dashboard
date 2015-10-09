require 'time_diff'

oba_communicator = OBACommunicator.new


targets = [
  {stop_no: 621, routes: ['71', '71E', '72', '72E', '73', '73E', '74']},
  {stop_no: 620, routes: ['301', '301E']}
]

SCHEDULER.every '1m', :first_in => 0 do |job|
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
    target_name = oba_communicator.getStopName(target_stop)
    data[target_name] = reported_routes
  end

  send_event('onebusaway', { targets: data })
end


class ETACreator

end
