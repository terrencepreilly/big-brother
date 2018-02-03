from django.urls import path

from .views import (
    ping,
    report,
)

urlpatterns = [
    path(r'ping/', ping, name='ping'),
    path(r'report/<str:site>/', report, name='report'),
]
