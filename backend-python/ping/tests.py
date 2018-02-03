from unittest import mock

from django.contrib.auth import get_user_model
from django.urls import reverse
from django.utils import timezone

from rest_framework import status
from rest_framework.test import APITestCase


class PingTest(APITestCase):

    def setUp(self):
        user = get_user_model()('test', 'test', 'test@test.com')
        self.client.force_authenticate(user)
        self.url = reverse('ping')

    @mock.patch('ping.views.redis')
    @mock.patch('ping.views.rstore')
    def test_can_ping_backend(self, mock_rstore, mock_redis):
        data = {'username': 'test user', 'site': 'test.com'}
        response = self.client.post(self.url, data=data, format='json')
        self.assertEqual(
            response.status_code,
            status.HTTP_200_OK,
            response.content,
        )
        self.assertEqual(
            response.json(),
            'Success',
        )
        self.assertTrue(
            mock_rstore.hmset.called,
        )

    @mock.patch('ping.views.redis')
    @mock.patch('ping.views.rstore')
    def test_ping_can_carry_message(self, mock_rstore, mock_redis):
        mock_hmset = mock.MagicMock()
        mock_rstore.hmset = mock_hmset
        data = {
            'username': 'Steve',
            'site': 'theskepticsguide.org',
            'message': 'Uploaded podcast.',
        }
        response = self.client.post(self.url, data=data, format='json')
        self.assertEqual(
            response.status_code,
            status.HTTP_200_OK,
            response.content,
        )
        self.assertEqual(
            response.json(),
            'Success',
        )
        positional, named = mock_hmset.call_args
        self.assertEqual(
            positional[0],
            'theskepticsguide.org:Steve',
        )
        data = positional[1]
        self.assertEqual(
            data['username'],
            'Steve',
        )
        self.assertEqual(
            data['message'],
            'Uploaded podcast.',
        )

class ReportTest(APITestCase):

    def setUp(self):
        user = get_user_model()('test', 'test', 'test@test.com')
        self.client.force_authenticate(user)

    @mock.patch('ping.views.redis')
    @mock.patch('ping.views.rstore')
    def test_reports_users_for_site(self, mock_rstore, mock_redis):
        mock_keys = mock.MagicMock()
        mock_keys.return_value = (x for x in ['rust-lang.org:gretchen'])
        mock_hgetall = mock.MagicMock()
        timestamp = str(timezone.now())
        mock_hgetall.return_value = {
            b'username': b'gretchen',
            b'site': b'test.com',
            b'timestamp': timestamp.encode(),
        }
        mock_rstore.keys = mock_keys
        mock_rstore.hgetall = mock_hgetall
        url = reverse('report', args=['rust-lang.org']) + '?duration=5'
        response = self.client.get(url)
        self.assertEqual(
            response.status_code,
            status.HTTP_200_OK,
            response.content,
        )
        data = response.json()
        self.assertEqual(
            data,
            {
                'gretchen': {
                    'username': 'gretchen',
                    'site': 'test.com',
                    'timestamp': timestamp,
                }
            }
        )
