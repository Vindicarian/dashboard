class RouteInfoFactory
  def initialize(entry)
    @entry = entry
    @name = entry['routeShortName']
    @scheduledDeparture = Time.at(entry['scheduledDepartureTime'] / 1000)
    @predictedDeparture = Time.at(entry['predictedDepartureTime'] / 1000)
    @tracked = entry['predicted']
    @current = Time.now
  end

  def getInfo
    @route_data = {
      departure_details: departureDetails(departureTime, getDiscrepancy),
      numStopsAway: @entry['numberOfStopsAway'],
      name: @entry['routeShortName'],
      signage: @entry['tripHeadsign'],
      eta: getETA
    }

  end

  #10:30 am
  def departureTime
    if @tracked
      @predictedDeparture.strftime('%k:%M%P')
    else
      @scheduledDeparture.strftime('%k:%M%P')
    end
  end

  def departureDetails(departure, discrepancy)
    departure + ' (' + discrepancy + ')'
  end

  #12 minutes and 40 seconds from now, 5 minutes ago
  def getETA
    if @tracked
      departing = @predictedDeparture
    else
      departing = @scheduledDeparture
    end

    delta = @current - departing
    delta > 0 ? state = '- ' : state = ''

    components = Time.diff(departing, @current, "#{state}%m")

    components[:minute] == 0 ? '0' : components[:diff]
  end

  #3 minutes delay or 2 minutes from now
  def getDiscrepancy
    if @tracked
      delta = @predictedDeparture - @scheduledDeparture
      discrepancy = Time.diff(@predictedDeparture, @scheduledDeparture)

      if discrepancy[:minute] == 0
        'on time'
      else
        discrepancy = discrepancy[:minute].to_s + ' minute'.pluralize(discrepancy[:minute])
        delta > 0 ? discrepancy + ' delay' : discrepancy + ' early'
      end
    else
      'scheduled'
    end

  end
end
