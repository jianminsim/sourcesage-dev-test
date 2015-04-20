# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import datetime
from django.utils.timezone import utc


class Migration(migrations.Migration):

    dependencies = [
        ('qa_forum', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='answer',
            name='created',
            field=models.DateField(default=datetime.datetime(2015, 4, 19, 3, 0, 44, 55765, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='question',
            name='created',
            field=models.DateField(default=datetime.datetime(2015, 4, 19, 3, 0, 51, 168047, tzinfo=utc), auto_now_add=True),
            preserve_default=False,
        ),
    ]
