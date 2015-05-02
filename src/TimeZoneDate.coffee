global = @

moment = if module? then require('moment-timezone') else global.moment

# Extending Date ensures `instanceof Date` is true and all methods are inherited.
class TimeZoneDate extends Date

  constructor: ->
    args = Array.prototype.slice.call(arguments)
    timeZone = undefined
    if args.length > 1 && typeof args[args.length - 1] == 'string'
      timeZone = args.pop()
    if args.length == 1
      args = args[0]
    if timeZone
      @_moment = moment.tz(args, timeZone)
      @_timeZone = timeZone
    else
      @_moment = moment(args)

  getDate: -> @_moment.date()
  getDay: -> @_moment.day()
  getFullYear: -> @_moment.year()
  getHours: -> @_moment.hours()
  getMilliseconds: -> @_moment.milliseconds()
  getMinutes: -> @_moment.minutes()
  getMonth: -> @_moment.month()
  getSeconds: -> @_moment.seconds()
  getTime: -> @_moment.valueOf()
  getTimezoneOffset: -> @_moment.utcOffset()
  getUTCDate: -> @_moment.clone().utc().date()
  getUTCDay: -> @_moment.clone().utc().day()
  getUTCFullYear: -> @_moment.clone().utc().year()
  getUTCHours: -> @_moment.clone().utc().hours()
  getUTCMilliseconds: -> @_moment.clone().utc().milliseconds()
  getUTCMinutes: -> @_moment.clone().utc().minutes()
  getUTCMonth: -> @_moment.clone().utc().month()
  getUTCSeconds: -> @_moment.clone().utc().seconds()
  getYear: -> throw new Error('getYear() is deprecated - use getFullYear() instead.')

  toString: -> @_moment.toString()
  valueOf: -> @_moment.toDate().getTime()

  getTimeZone: -> @_timeZone
  toLocalDate: -> @_moment.toDate()

if module? then module.exports = TimeZoneDate
