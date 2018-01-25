import redis

from django.utils import timezone
from django.conf import settings

from rest_framework.response import Response
from rest_framework.decorators import api_view


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
