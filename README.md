# Big Brother

A small script and backend for monitoring user statistics on a website.
The script sends pings on a pre-determined interval to a backend which
stores the information in redis.

This script is intended for use by small sites which have a couple of
users, perhaps doing data-intensive tasks. If developers would like
to roll out changes, they can view which users are currently logged
in (and what they up to.)

## Usage

First, you must have [Elm](http://elm-lang.org) and Make,
[Docker](https://www.docker.com/), and
[docker-compose](https://docs.docker.com/compose/) installed.

1. Clone the repository.

```
git clone https://github.com/terrencepreilly/big-brother
cd big-brother
```

2. Make the frontend script.

```
make
```

The file, `BigBrother.js`, should have been created.

3. Go into the Python backend and bring it up with docker-compose.

```
cd backend-python
sudo docker-compose up -d
```

If you look at the running docker processes, you should see two:
backend-redis and backend:

```
sudo docker ps
```

4. Serve the index file.

```
cd ..
python3 -m http.server 8080
```

## Deploying

Whichever site you are using this script on must be added to
the Django CORS whitelist.  This is located in the file
`backend-python/backend/settings.py`, and is labelled
*CORS_ORIGIN_WHITELIST*.


## TODO/Roadmap

Some task which have to be done before this is fully usable:

- [ ] Add a port which allows users to change the message sent.
- [x] Add a flag member which tells where the backend server is
      to be found.
- [x] Add an endpoint to backend-python which, given site, returns:
  - [x] all users
  - [x] all timestamps
  - [x] all messages

Some possible features in the future:

- [ ] A site for representing the users logged in and their
      current tasks in real-time.
- [ ] A Haskell backend.  (This is mostly for fun, or for those
      who do not want/cannot use Python.  Even though it's
      containerized here.)
