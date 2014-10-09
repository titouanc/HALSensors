PERIODS = [
  ["1h", "Last hour"],
  ["6h", "Last 6 hours"],
  ["12h", "Last 12 hours"],
  ["1d", "Last day"],
  ["1w", "Last week"]
]

PERIODS_TABLE = {}

w = ->
  0.75 * $(window).width()

h = ->
  0.75 * ($(window).height() - ($('.navbar-fixed-top').height() + $('.footer').height()))

now = ->
  new Date().getTime()

imgurl = (duration, width, height) -> 
  "http://graphite.partou.se/render/?target=alias%28secondYAxis%28movingAverage%28hal.sensors.light.inside%2C6%29%29%2C%22Light%20inside%22%29&target=alias%28secondYAxis%28movingAverage%28hal.sensors.light.outside%2C6%29%29%2C%22Light%20outside%22%29&target=alias%28movingAverage%28hal.sensors.temp.ambiant%2C6%29%2C%22Ambiant%20temp%22%29&target=alias%28movingAverage%28hal.sensors.temp.radiator%2C6%29%2C%22Radiator%20temp%22%29&target=alias%28drawAsInfinite%28events%28%22bell%22%29%29%2C%22Bell%22%29&target=alias%28drawAsInfinite%28events%28%22open%22%29%29%2C%22Open%22%29&target=alias%28drawAsInfinite%28events%28%22close%22%29%29%2C%22Close%22%29&lineWidth=2&height=#{height}&width=#{width}&from=-#{duration}##{now()}"

get_duration = ->
  duration = window.location.hash.replace('#', '')
  if (! duration || duration not of PERIODS_TABLE)
    window.location.hash = '#1h'
    duration = '1h'
  return duration

# Document ready
$ ->
  nav = $('#graph-nav')
  W = w()
  H = h()
  timeouted_op = undefined

  # $("#content").on("swipeleft") -> alert("Swipe left !")

  # Reload image function
  show_image = (duration) ->
    if duration is undefined
      duration = get_duration()
    plot = imgurl(duration, W, H)
    $('#graph-plot').replaceWith("<img id=\"graph-plot\" src=\"#{plot}\"/>")
    $('#graph-title').text(PERIODS_TABLE[duration])
    $('#graph-nav li.active').removeClass('active')
    $("#graph-nav a[href=##{duration}]").parent().addClass('active')
    
    # Reload image at least every minute
    clearTimeout(timeouted_op)
    timeouted_op = setTimeout show_image, 60000

  # Build navigation list
  for period in PERIODS
    duration = period[0]
    name = period[1]
    PERIODS_TABLE[duration] = name
    nav.append "<li><a href=\"##{duration}\">#{name}</a></li>"

  # Attach handlers to navigation list events
  nav.find(':first-child').addClass('active')
  $('#graph-nav a').click (e) ->
    duration = $(this).attr('href').replace('#', '')
    name = $(this).text()
    show_image duration, name

  # Reload image on resize
  $(window).resize (e) ->
    W = w()
    H = h()
    show_image()

  # First image load
  show_image(get_duration())
