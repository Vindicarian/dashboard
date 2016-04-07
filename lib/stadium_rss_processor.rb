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

    events.map! do |item|
      {
        title: item.title,
        start: DateTime.parse(item.category).to_i
      }
    end

    events.uniq { |e| e[:title] }[0..1]
  end

  def filterEvents(events)
    events.select do |item|
      date = item.dtstart ||
        DateTime.parse(item.category)

      isTodayOrWithinTwoWeeks(date) && !isWeekend(date)
    end
  end

  def isWeekend(date)
    date.sunday? || date.saturday?
  end

  def isTodayOrWithinTwoWeeks(date)
    delta = (date.day - @current.day)
    delta >= 0 && delta <= 14
  end
end

