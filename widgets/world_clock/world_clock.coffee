class Dashing.WorldClock extends Dashing.Widget
  # configuration
  #could tidy this up: empty area array under main section, move SEA
  locations: [
    { zone: "America/Los_Angeles", display_location: "WEST", areas: [{ loc: "SFO"},{ loc: "PA" },{ loc: "LAX" }],offset:true , left:true},
    { zone: "America/Los_Angeles", display_location: "MAIN", areas:[], primary:true }
    { zone: "America/New_York", display_location: "EAST", areas: [ {loc:"NYC"}, {loc:"TOR"}, {loc:"BOS"}, {loc:"D.C."}], right:true}
    { zone: "America/Denver", display_location: "MIDWEST", areas:[ {loc: "DEN"}, {loc: "BDR"}]}
    { zone: "America/Chicago", display_location: "MIDEAST", areas:[ {loc: "CHI"}], offset: true}
    { zone: "Asia/Tokyo", display_location: "JAPAN", areas:[{loc: "TKY"}]}
    { zone: "Europe/London", display_location: "ENGLANDIRELAND", areas: [{loc:"LON"}, {loc:"DUB"}]}
    { zone: "Asia/Vladivostok", display_location: "SYDNEY", areas: [{loc:"SYD"}]}
    { zone: "Asia/Hong_Kong", display_location: "CHINA", areas: [{loc:"HKG"}, {loc: "SG"}], offset:true}
  ]


#    { zone: "America/Los_Angeles", display_location: "SF"},
#    { zone: "America/Los_Angeles", display_location: "LAX"}
#    { zone: "America/Denver", display_location: "DEN"},
#    { zone: "America/New_York", display_location: "NYC" },
#    { zone: "America/Toronto", display_location: "TOR"}
#    { zone: "Europe/London", display_location: "LON" }
#    { zone: "Asia/Tokyo", display_location: "TKY"}

  startClock: ->
    for location in @locations
      date = moment().tz(location.zone)
      location.time = [date.hours(), date.minutes(), date.seconds()].map (n)->
        ('0' + n).slice(-2)
      .join(':')

      #location.time are properly formatted times at this point

      #i think this is dictating width of clock?
      minutes = 60 * date.hours() + date.minutes()
      totalWidth = document.querySelector('.hours').clientWidth - 1
      offset = (minutes / (24.0 * 60)) * totalWidth


      #per browser basis, translates the queryselector'd display locations on X according to width/offset dictated above
      clock = document.querySelector("." + location.display_location)
      if(clock)
        ['-webkit-transform', '-moz-transform', '-o-transform', '-ms-transform', 'transform'].forEach (vendor) ->
          clock.style[vendor] = "translateX(" + offset + "px)"

          if(location.primary)
            @set('time', location.time)
        , @

    setTimeout @startClock.bind(@), 1000

  setupHours: ->
    hours = []
    for h in [0..23]
      do (h) ->
        hours[h] = {}
        hours[h].dark = h< 7 || h>= 19
        hours[h].name = if h == 12 then h else h%12
    @set('hours', hours)

  ready: ->
    @setupHours()
    @startClock()
