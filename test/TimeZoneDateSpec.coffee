expect = require('chai').expect
_ = require('underscore')
TimeZoneDate = require('../src/TimeZoneDate')

describe 'A TimeZoneDate', ->

  it 'can be constructed', ->
    date = new TimeZoneDate()
    expect(date).not.to.equal(null)
    expect(date.toString()).not.to.equal(null)

  it 'can be constructed with a timezone', ->
    samples = createSampleDates()
    expect(samples).to.have.length.above(0)
    _.each samples, (sample) ->
      expect(sample.date.toString()).to.equal(sample.getters.toString)

  it 'can be queried', ->
    samples = createSampleDates()
    expect(samples).to.have.length.above(0)
    _.each samples, (sample) ->
      date = sample.date
      _.each sample.getters, (value, getter) ->
        actual = date[getter]()
        try
          expect(actual).to.equal(value)
        catch e
          console.error('Failed for getter ' + getter + ' and date ' + date.toString())
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
  samples = [
    {
      date: new TimeZoneDate(dateStr, 'Australia/Melbourne')
      getters:
        toString: 'Sat May 02 2015 18:15:14 GMT+1000'
        getTime: 1430554514000
        getTimezoneOffset: 600
        getUTCDate: 2
        getUTCDay: 6
        getUTCHours: 8
    }
    {
      date: new TimeZoneDate(dateStr, 'America/New_York')
      getters:
        toString: 'Sat May 02 2015 18:15:14 GMT-0400'
        getTime: 1430604914000
        getTimezoneOffset: -240
        getUTCDate: 2
        getUTCDay: 6
        getUTCHours: 22
    }
  ]
  _.each samples, (sample) -> _.extend(sample.getters, commonGetters)
  samples
