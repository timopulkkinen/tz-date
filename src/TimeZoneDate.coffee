isNode = module?.exports?
# Using a different variable name for moment to avoid re-declaring it in CoffeeScript and shadowing
# the global variable.
momentLib = if isNode then require('moment-timezone') else moment

# Extending Date ensures `instanceof Date` is true and all methods are inherited.
class TimeZoneDate extends Date

  constructor: ->
    args = Array.prototype.slice.call(arguments)
    lastArg = args[args.length - 1]
    timeZone = undefined
    if args.length > 1 && (!lastArg? || typeof lastArg == 'string')
      timeZone = args.pop()
    if args.length == 1
      args = args[0]
    if timeZone
      @_moment = momentLib.tz(args, timeZone)
      @_timeZone = timeZone
    else
      @_moment = momentLib(args)

  _fromUtc: ->
    @_moment = momentLib.tz(@_utcMoment, @_timeZone)
    @_moment
  _fromMomentArg: (arg) ->
    @_moment = momentLib.tz(arg, @_timeZone)
    @_getForSetter()
  _getUtc: -> @_utcMoment ?= @_moment.clone().utc()
  _getForSetter: ->
    @_utcMoment = null
    @_moment

  # Getters

  getDate: -> @_moment.date()
  getDay: -> @_moment.day()
  getFullYear: -> @_moment.year()
  getHours: -> @_moment.hours()
  getMilliseconds: -> @_moment.milliseconds()
  getMinutes: -> @_moment.minutes()
  getMonth: -> @_moment.month()
  getSeconds: -> @_moment.seconds()
  getTime: -> @_moment.valueOf()
  getTimezoneOffset: -> -@_moment.utcOffset()
  getUTCDate: -> @_getUtc().date()
  getUTCDay: -> @_getUtc().day()
  getUTCFullYear: -> @_getUtc().year()
  getUTCHours: -> @_getUtc().hours()
  getUTCMilliseconds: -> @_getUtc().milliseconds()
  getUTCMinutes: -> @_getUtc().minutes()
  getUTCMonth: -> @_getUtc().month()
  getUTCSeconds: -> @_getUtc().seconds()
  getYear: -> throw new Error('getYear() is deprecated - use getFullYear() instead.')

  # Setters

  setDate: (value) -> @_getForSetter().date(value)
  setFullYear: (value) -> @_getForSetter().year(value)
  setHours: (value) -> @_getForSetter().hours(value)
  setMilliseconds: (value) -> @_getForSetter().milliseconds(value)
  setMinutes: (value) -> @_getForSetter().minutes(value)
  setMonth: (value) -> @_getForSetter().month(value)
  setSeconds: (value) -> @_getForSetter().seconds(value)
  setTime: (value) -> @_fromMomentArg(momentLib.unix(value / 1000))
  setUTCDate: (value) -> @_fromUtc @_getUtc().date(value)
  setUTCFullYear: (value) -> @_fromUtc @_getUtc().year(value)
  setUTCHours: (value) -> @_fromUtc @_getUtc().hours(value)
  setUTCMilliseconds: (value) -> @_fromUtc @_getUtc().milliseconds(value)
  setUTCMinutes: (value) -> @_fromUtc @_getUtc().minutes(value)
  setUTCMonth: (value) -> @_fromUtc @_getUtc().month(value)
  setUTCSeconds: (value) -> @_fromUtc @_getUtc().seconds(value)
  setYear: (value) -> throw new Error('setYear() is deprecated - use setFullYear() instead.')

  toString: ->
    if @_timeZone
      str = @_moment.toString()
      abbr = @_moment.zoneAbbr()
      if abbr
        str = str + " (#{abbr})"
      str
    else
      @_moment.toDate().toString()
  valueOf: -> @_moment.toDate().getTime()

  getTimeZone: -> @_timeZone
  toLocalDate: -> @_moment.toDate()
  clone: -> new TimeZoneDate(@_moment, @_timeZone)
  equals: (other) -> @_moment.toString() == other.toString()

if isNode
  module.exports = TimeZoneDate
else if window?
  window.TimeZoneDate = TimeZoneDate
