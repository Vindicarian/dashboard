require_relative 'stadium_rss_processor'

class Events
  @@calendars = { #Public_Pivotal_Seattle_Events: "https://www.google.com/calendar/ical/pivotal.io_qgrlap9ooml7tojb6i3rou6dag%40group.calendar.google.com/public/basic.ics",
              CenturyLink_Events: "http://www.trumba.com/calendars/centurylink-field-events-calendar.ics",
              Safeco_Events: "https://calendar.google.com/calendar/ical/oku5mamlo4ddkutvcg6u736rt4i91nur%40import.calendar.google.com/public/basic.ics" }

  @@data = Array.new

  def setData(toData)
    @data = toData
  end

  def getAllEvents
    all_events = Array.new()

    @@calendars.each do |cal_name, cal_uri|
      ics  = open(cal_uri) { |f| f.read }
      cal = Icalendar.parse(ics).first

      all_events = all_events | cal.events
    end

    all_events
  end

  def getResult
    @data.map do |e|
      start = e.dtstart

      today = start == Date.today
      tomorrow = start == Date.tomorrow
      if e.methods.include? :title
        title=e.title
      else
        title=e.summary
      end
      {
        title: title,
        start: start.to_time.to_s,
        end: e.dtend.to_time.to_i,
        today: today,
        tomorrow: tomorrow
      }
    end
  end

  def sort
    @data.sort{ |a, b| a.dtstart.to_time.utc <=> b.dtstart.to_time.utc }[0..1]
  end

  def filter
    @data.select{ |e| e.dtend.to_time.utc > Time.now.utc }
    @data.each do |e|
      p e
    end
    @data.uniq!{ |e| e.title }[0..1]
  end
end
