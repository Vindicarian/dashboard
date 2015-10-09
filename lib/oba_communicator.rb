require 'net/https'

class OBACommunicator
  @@OBA_KEY = 'TEST'

  def getArrivalsAtStop(stop_number)
    response = send_oba_request("arrivals-and-departures-for-stop/1_#{stop_number}.json")
    response.body
  end

  def getStopName(stop_number)
    response = send_oba_request("stop/1_#{stop_number}.json")
    response.body
    response_obj = JSON.parse(response.body)
    response_obj['data']['entry']['name']
  end

  private

  def send_oba_request(api_call)
    oba_uri = URI.parse("http://api.pugetsound.onebusaway.org/api/where/#{api_call}?key=#{@@OBA_KEY}")

    request = Net::HTTP::Get.new(oba_uri.request_uri)

    http = Net::HTTP.new(oba_uri.host, 80)

    http.request(request)
  end
end
