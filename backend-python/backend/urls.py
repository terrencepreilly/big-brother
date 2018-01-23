from django.urls import path, include

urlpatterns = [
    path('', include('ping.urls'))
]
