from django.contrib.auth.models import User
from django.db import models

class Question(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField()
    asker = models.CharField(max_length=40)
    created = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return u"{}: {}".format(self.asker, self.title)

class Answer(models.Model):
    comment = models.TextField()
    raiser = models.CharField(max_length=40)
    pointQ = models.ForeignKey(Question, related_name='answer_question')
    created = models.DateTimeField(auto_now_add=True)

    def __unicode__(self):
        return u"{} \"{}\"".format(self.raiser, self.comment)




