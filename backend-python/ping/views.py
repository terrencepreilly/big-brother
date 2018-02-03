from datetime import timedelta

from django.conf import settings
from django.utils import timezone
from django.utils.dateparse import parse_datetime

from rest_framework.response import Response
from rest_framework.decorators import api_view
import redis


rstore = redis.StrictRedis(
    host=settings.REDIS_HOST,
    port=settings.REDIS_PORT,
    db=settings.REDIS_DB,
)


@api_view(['POST'])
def ping(request):
    data = {'timestamp': timezone.now()}
    data.update(request.data)
    username = data.get('username', None)
    site = data.get('site', None)
    if username is None or site is None:
        return Response({
            'username': 'This field is required',
            'site': 'This field is required',
        }, status=400)
    rstore.hmset(f'{site}:{username}', data)
    return Response('Success')


@api_view(['GET'])
def report(request, site):
    keys = rstore.keys(f'{site}.*')
    users = list()
    current_time = timezone.now()
    duration = int(request.GET.get('duration', '10'))
    for key in keys:
        data = rstore.hgetall(key)
        if data is None:
            continue
        timestamp = data.get(b'timestamp', None)
        if timestamp is None:
            continue
        timestamp = parse_datetime(timestamp.decode())
        if current_time - timestamp < timedelta(seconds=duration):
            username = data.get(b'username', None)
            if username is not None:
                users.append(username)
    return Response({'users': users})
