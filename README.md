# Big Brother

A small script and backend for monitoring user statistics on a website.
The script sends pings on a pre-determined interval to a backend which
stores the information in redis.

This script is intended for use by small sites which have a couple of
users, perhaps doing data-intensive tasks. If developers would like
to roll out changes, they can view which users are currently logged
in (and what they up to.)

## Usage

First, you must have [Elm](http://elm-lang.org), GNU Make,
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

## Discription of Project Layout

The relevant files for customizing/using *BigBrother* are as
follows:
    .
    ├── backend-python/
    │   ├── backend/
    │   │   ├── settings.py
    │   │   └── ...
    │   ├── ping/
    │   │   ├── views.py
    │   │   └── ...
    │   └── ...
    ├── Makefile
    ├── index.html
    ├── scripts/
    │   ├── BigBrother.elm
    │   ├── BigBrotherReporter.elm
    │   ├── Message.elm
    │   └── ...
    ├── tests/
    │   ├── BigBrotherTests.elm
    │   └── ...
    └── ...

A description of the purpose of each follows:
- `backend-python/backend/settins.py`: The settings file for the backend.
  The most relevant setting is `CORS_ORIGIN_WHITELIST`.  Currently, it
  only contains the string, "localhost:8080".  Whichever origins you're
  using the scripts from have to be included here.  For example, if I
  were to include this script in *www.example.com*, I would put
```
    CORS_ORIGIN_WHITELIST = (
        "www.example.com",
    )
```
  See [django-cors-headers](https://github.com/ottoyiu/django-cors-headers)
  for details.

  If you are not running on Docker, the redis settings are included
  here (`REDIS_HOST`, `REDIS_PORT`, and `REDIS_DB` will have to be
  defined.)
- `backend-python/ping/views.py`: The views which do the work of
  communicating with redis.  If you are changing the items stored,
  you would do it here.
- `Makefile`: The build instructions. Add build instructions for new scripts
  here.
- `index.html`: An example of using the frontend scripts.
- `scripts/BigBrother.elm`: The script which pings a backend.  You would
  include this in the site visited by the client. If you would like to
  edit the content of items stored in redis, you would do so here.
- `scripts/BigBrotherReporter.elm`: The script which asks for a list
  of usernames and messages from the backend.  If you would like to add
  additional report formats, you would do so here.
- `scripts/Message.elm`: Describes the message model.  Views for the message
  and serializers are described here.  You would update this file if you
  are communicating additional information to/from the backend.
- `tests/BigBrotherTests.elm`: Some simple tests.  These can provide
  usage examples, and may help while you change things.


## TODO/Roadmap

Some task which have to be done before this is fully usable:

- [ ] Add a port which allows users to change the message sent.
- [ ] A flag for the reporter script which allows:
    - [ ] for data of different formats to be sent back,
- [x] Add a flag member which tells where the backend server is
      to be found.
- [x] Add an endpoint to backend-python which, given site, returns:
  - [x] all users
  - [x] all timestamps
  - [x] all messages
- [x] A site for representing the users logged in and their
      current tasks in real-time.

Some possible features in the future:

- [ ] A Haskell backend.  (This is mostly for fun, or for those
      who do not want/cannot use Python.  Even though it's
      containerized here.)
