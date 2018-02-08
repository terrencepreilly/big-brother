# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.0.1] - 2018-02-07

### Added
- A script for pinging a redis backend with a username and message.
- A script for retrieving information from the redis backend and
  rendering it as a simple list of usernames and messages.
- A redis backend using Python which can be pinged (and which
  stores a username and backend as well as a timestamp.)  It also
  has an endpoint for reporting which users have reported in
  the last so many seconds.
- Added a changelog.
