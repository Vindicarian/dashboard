require 'time_diff'

oba_communicator = OBACommunicator.new


targets = [
  {stop_no: 621, routes: ['71', '71E', '72', '72E', '73', '73E', '74']},
  {stop_no: 620, routes: ['301', '301E']},
  {stop_no: 1535, routes: ['16', '16E', '99', '99E']},
  {stop_no: 843, routes: ['214', '214E', '554', '554E']}
]


SCHEDULER.every '1m', :first_in => 0 do |job|
  data = {}
  targets.each do |target|
    response_obj = JSON.parse(oba_communicator.getArrivalsAtStop(target[:stop_no]))
    entries = response_obj['data']['entry']['arrivalsAndDepartures']

    entries.select! do |entry|
      route = entry['routeShortName']
      target[:routes].include?(route)
    end

    stop_no = target[:stop_no]
    stop_name = oba_communicator.getStopName(stop_no)

    data[stop_name] = RouteInfoFactory.new(entries).getInfo
  end

  send_event('onebusaway', { targets: data })
end
