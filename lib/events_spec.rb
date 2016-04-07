require 'rspec'
require 'icalendar'
require_relative 'events'

describe 'filter and sort events' do
  let(:now) { DateTime.now() }
  let(:yesterday_event) { Icalendar::Event.new() }
  let(:earlier_event) { Icalendar::Event.new() }
  let(:overlap_event) { Icalendar::Event.new() }
  let(:later_event) { Icalendar::Event.new() }
  let(:tomorrow_event) { Icalendar::Event.new() }

  let(:subject) { Events.new }
  let(:data) { [tomorrow_event, earlier_event, later_event, overlap_event, yesterday_event, later_event] }

  before do
    subject.setData(data)

    earlier_event.title = 'earlier'
    earlier_event.dtstart = 2.hours.ago.to_datetime
    earlier_event.dtend = 1.hour.ago.to_datetime

    overlap_event.title = 'overlap'
    overlap_event.dtstart = 2.hours.ago.to_datetime
    overlap_event.dtend = 1.hour.from_now.to_datetime

    later_event.title = 'later'
    later_event.dtstart = 1.hour.from_now.to_datetime
    later_event.dtend = 2.hours.from_now.to_datetime

    yesterday_event.title = 'yesterday'
    yesterday_event.dtstart = 1.day.ago.to_datetime
    yesterday_event.dtend = (1.day.ago + 1.hour).to_datetime

    tomorrow_event.title = 'tomorrow'
    tomorrow_event.dtstart = 1.day.from_now.to_datetime
    tomorrow_event.dtend = (1.day.from_now + 1.hour).to_datetime
  end

  describe 'filter' do
    fit 'filters out finished events' do
      filtered = subject.filter
      expect(filtered.count).to eq(3)
      expect(filtered).to include(later_event)
      expect(filtered).to include(overlap_event)
      expect(filtered).to include(tomorrow_event)
    end
  end

  describe 'sort' do
    it 'sorts events by end datetime' do
      sorted = subject.sort
    end
  end

end
