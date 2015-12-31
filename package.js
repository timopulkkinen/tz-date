// Meteor package definition.
Package.describe({
  name: 'aramk:tz-date',
  version: '0.2.3',
  summary: 'A Date class in JavaScript with support for time zones.',
  git: 'https://github.com/aramk/tz-date.git'
});

Package.onUse(function (api) {
  api.versionsFrom('METEOR@0.9.0');
  api.use([
    'coffeescript',
    'underscore',
    'risul:moment-timezone@0.3.0_1'
  ], ['client', 'server']);
  api.export([
    'TimeZoneDate'
  ], ['client', 'server']);
  api.addFiles([
    'src/TimeZoneDate.coffee',
  ], ['client', 'server']);
});
