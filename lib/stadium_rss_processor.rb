require 'rubygems'
require 'simple-rss'
require 'open-uri'


class StadiumRSSProcessor

  def initialize
    @current = DateTime.now
  end

  def getEvents
    response = SimpleRSS.parse open("http://www.trumba.com/calendars/centurylink-field-events-calendar.rss")

    events = response.items

    events = filterEvents(events)

    events.map do |item|
      {
        title: item.title,
        start: DateTime.parse(item.category).to_i
      }
    end

    events.uniq { |e| e.title }[0..1]
  end

  def filterEvents(events)
    events.select do |item|
      date = DateTime.parse(item.category)

      !isWeekend(date) && isTodayOrWithinTwoWeeks(date)
    end
  end

  def isWeekend(date)
    date.sunday? || date.saturday?
  end

  def isTodayOrWithinTwoWeeks(date)
    delta = Time.parse(@current.to_s) - Time.parse(date.to_s)

    diff = Time.diff(@current, date);

    if delta > 0
      diff[:week] == 0 && diff[:day] <= 1
    else
      diff[:week] <= 2
    end
  end
end

