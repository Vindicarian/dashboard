class RouteInfoFactory
  def initialize(entries)
    @current = Time.now
    @entries = entries
    @data = {}

    @entries.each do |e|
      route = e['routeShortName']
      unless @data[route]
        @data[route] = []
      end
    end
  end

  def getInfo
    @entries.each do |e|
      eta = getETA(e)
      route = e['routeShortName']

      @data[route] << eta
    end

    @data.each do |key, val|
      count = val.length - 1
      @data[key] = val.sort[0..4].map.with_index do |eta, index|
        index != count ? eta += ', ' : eta
      end
    end

    if @data.keys.length == 0
      @data['ignore'] = true
    end

    @data
  end

  def getETA(entry)
    if entry['predicted']
      departing = Time.at(entry['predictedDepartureTime'] / 1000)
    else
      departing = Time.at(entry['scheduledDepartureTime'] / 1000)
    end

    delta = @current - departing
    delta > 0 ? state = '- ' : state = ''

    components = Time.diff(departing, @current, "#{state}%m")

    components[:minute] == 0 ? '0' : components[:diff]
  end
end
