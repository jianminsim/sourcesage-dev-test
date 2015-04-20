from django.conf.urls import include, url
from django.contrib import admin

urlpatterns = [
    url(r'^$', 'qa_forum.views.index', name='index'),
    url(r'^admin/', include(admin.site.urls)),

# ajax
    url(r'^answer_form/$', 'qa_forum.views.answer_form', name='answer_form'),
]