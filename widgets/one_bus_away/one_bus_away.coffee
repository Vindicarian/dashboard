class Dashing.OneBusAway extends Dashing.Widget

  ready: ->
    eta_sections = $('.route-etas')
    _.each eta_sections, (etas) ->
      num_etas = $(etas).find('.eta').length
      _.each $(etas).find('.eta'), (eta, i) ->
        val = $(eta).text()
        val = val + ',' if (i != (num_etas - 1))
        $(eta).text(val)
