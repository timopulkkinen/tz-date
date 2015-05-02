expect = require('chai').expect
TimeZoneDate = require('../src/TimeZoneDate')

describe 'A TimeZoneDate', ->

  it 'can be constructed', ->
    date = new TimeZoneDate()
    expect(date).not.to.equal(null)

  