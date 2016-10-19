expect = require('chai').expect
_ = require('underscore')
TimeZoneDate = require('../src/TimeZoneDate')

describe 'A TimeZoneDate', ->

  it 'can be constructed', ->
    date = new TimeZoneDate()
    expect(date).not.to.equal(null)
    expect(date.toString()).not.to.equal(null)

  it 'can be constructed from a string with a timezone', ->
    date = new Date('Fri Jun 12 2015 11:14:42 GMT+1000 (AEST)')
    # Deprecated
    # date2 = new TimeZoneDate('Fri Jun 12 2015 11:14:42 GMT+1000 (AEST)')
    # date3 = new TimeZoneDate('Fri Jun 12 2015 11:14:42 GMT+1000 (AEST)', 'Australia/Melbourne')
    date2 = new TimeZoneDate('2015-06-12T11:14:42+10:00')
    date3 = new TimeZoneDate('2015-06-12T11:14:42+10:00', 'Australia/Melbourne')



    # we should get the time in current system timezone
    expect(date.toString()).to.equal(date2.toString())
    # parsed epoch should be the same for both
    expect(date2.getTime() == date3.getTime())

    #  argument list handling
  it 'can be constructed from varargs with or without timezone', ->
    date = new Date('Fri Jun 12 2015 11:14:42')
    date2 = new Date(2015, 5, 12, 11, 14, 42)

    tzDate = new TimeZoneDate(2015, 5, 12, 11, 14, 42)
    tzDate2 = new TimeZoneDate(2015, 5, 12, 11, 14, 42, 'Australia/Melbourne')
    tzDate3 = new TimeZoneDate('2015-06-12T11:14:42', 'Australia/Melbourne')

    expect(date.toString()).to.equal(tzDate.toString())
    expect(date2.toString()).to.equal(tzDate.toString())

    expect(tzDate2.toString()).to.equal(tzDate3.toString())

  it 'can be constructed with a timezone', ->
    samples = createSampleDates()
    expect(samples).to.have.length.above(0)
    _.each samples, (sample) ->
      expect(sample.date.toString()).to.equal(sample.getters.toString)

  it 'can be cloned', ->
    date = createSampleDates()[0].date
    clone = date.clone()
    expect(date.toString()).to.equal(clone.toString())

  it 'can be queried', ->
    samples = createSampleDates()
    expect(samples).to.have.length.above(0)
    _.each samples, (sample) ->
      date = sample.date
      expect(_.keys(sample.getters)).to.have.length.above(0)
      _.each sample.getters, (value, getter) ->
        actual = date[getter]()
        try
          expect(actual).to.equal(value)
        catch e
          console.error('Failed for getter ' + getter + ' and date ' + date.toString())
          throw e

  it 'can be modified', ->
    samples = createSampleDates()
    expect(samples).to.have.length.above(0)
    _.each samples, (sample) ->
      date = sample.date.clone()
      expect(_.keys(sample.setters)).to.have.length.above(0)
      _.each sample.setters, (value, setter) ->
        try
          getter = setter.replace(/^s/, 'g')
          existing = date[getter]()
          expect(existing).not.to.equal(value)
          date[setter](value)
          expect(date[getter]()).to.equal(value)
        catch e
          console.error('Failed for setter ' + setter + ' and date ' + date.toString())
          throw e

# Test at least two different timezones in case the tests are run in one of them.
createSampleDates = ->
  dateStr = '2015-05-02T18:15:14'
  commonGetters =
    getDate: 2
    getDay: 6
    getFullYear: 2015
    getHours: 18
    getMilliseconds: 0
    getMinutes: 15
    getMonth: 4
    getSeconds: 14
    getUTCFullYear: 2015
    getUTCMilliseconds: 0
    getUTCMinutes: 15
    getUTCMonth: 4
    getUTCSeconds: 14
  commonSetters =
    setDate: 5
    setFullYear: 2016
    setHours: 20
    setMilliseconds: 10
    setMinutes: 20
    setMonth: 5
    setSeconds: 16
    setTime: 1430550000000
    setUTCDate: 5
    setUTCFullYear: 2016
    setUTCHours: 20
    setUTCMilliseconds: 10
    setUTCMinutes: 20
    setUTCMonth: 5
    setUTCSeconds: 16
  samples = [
    {
      date: new TimeZoneDate(dateStr, 'Australia/Melbourne')
      getters:
        toString: 'Sat May 02 2015 18:15:14 GMT+1000 (AEST)'
        getTime: 1430554514000
        getTimezoneOffset: -600
        getUTCDate: 2
        getUTCDay: 6
        getUTCHours: 8
    }
    {
      date: new TimeZoneDate(dateStr, 'America/New_York')
      getters:
        toString: 'Sat May 02 2015 18:15:14 GMT-0400 (EDT)'
        getTime: 1430604914000
        getTimezoneOffset: 240
        getUTCDate: 2
        getUTCDay: 6
        getUTCHours: 22
    }
  ]
  _.each samples, (sample) ->
    sample.getters = _.extend({}, commonGetters, sample.getters)
    sample.setters = _.extend({}, commonSetters, sample.setters)
  samples
