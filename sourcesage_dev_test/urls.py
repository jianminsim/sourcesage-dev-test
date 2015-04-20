from django.conf.urls import include, url
from django.contrib import admin

urlpatterns = [
    # Examples:
    url(r'^$', 'qa_forum.views.index', name='index'),


# ajax
    url(r'^answer_form/$', 'qa_forum.views.answer_form', name='answer_form'),

    url(r'^admin/', include(admin.site.urls)),
]

