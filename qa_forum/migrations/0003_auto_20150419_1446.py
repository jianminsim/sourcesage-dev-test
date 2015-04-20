# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('qa_forum', '0002_auto_20150419_0300'),
    ]

    operations = [
        migrations.RenameField(
            model_name='answer',
            old_name='statement',
            new_name='comment',
        ),
        migrations.AlterField(
            model_name='answer',
            name='created',
            field=models.DateTimeField(auto_now_add=True),
        ),
        migrations.AlterField(
            model_name='question',
            name='created',
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]
