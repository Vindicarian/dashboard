require 'net/http'
require 'icalendar'
require 'open-uri'
require_relative '../lib/events'

# List of calendars
#
# Format:
#   <name> => <uri>
# Example:
#   hangouts: "https://www.google.com/calendar/ical/<hash>.calendar.google.com/private-<hash>/hangouts.ics"

SCHEDULER.every '30m', :first_in => 0 do |job|
  events = Events.new
  events.setData(events.getAllEvents)
  sendEvents = events.getResult

  send_event("google_calendar", {events: sendEvents})
                                 #stadium_events: stadium_events})
    #send_event("google_calendar", {events: {title:'title', start:1.hour.from_now, end:2.hours.from_now}})
end
