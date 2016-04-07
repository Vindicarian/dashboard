require 'active_support'
require 'rspec'
require_relative 'stadium_rss_processor'
require 'icalendar'

describe 'StadiumRSSProcessor' do
  let(:subject) { StadiumRSSProcessor.new }

  fdescribe 'isTodayOrWithinTwoWeeks' do
    it 'is today' do
      expect(subject.isTodayOrWithinTwoWeeks(1.second.from_now)).to be_truthy
    end

    it 'is within two weeks' do
      expect(subject.isTodayOrWithinTwoWeeks(1.day.from_now)).to be_truthy
      expect(subject.isTodayOrWithinTwoWeeks(2.weeks.from_now - 1.day)).to be_truthy
    end

    it 'is not within two weeks' do
      edge = 2.weeks.from_now + 1.day
      expect(subject.isTodayOrWithinTwoWeeks(edge)).to be_falsy
    end

    it 'is alread passed' do
      expect(subject.isTodayOrWithinTwoWeeks(1.day.ago)).to be_falsy
    end
  end

  describe 'filterEvents' do
   let(:today_event) { double('Icalendar::Event',
                              title: 'Item1', dtstart:4.hours.from_now) }
    let(:later_event) { double('Icalendar::Event',
                              title: 'Item2',
                              dtstart:(2.weeks.from_now + 1.day)) }
    let(:all_events) { [today_event, later_event] }
    let(:subject) { StadiumRSSProcessor.new }

    it 'returns events less than two weeks old' do
      expect(subject.filterEvents(all_events).count).to eq 1
    end

  end
end
