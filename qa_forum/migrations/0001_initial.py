# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Answer',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('statement', models.TextField()),
                ('raiser', models.CharField(max_length=40)),
            ],
        ),
        migrations.CreateModel(
            name='Question',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('title', models.CharField(max_length=100)),
                ('description', models.TextField()),
                ('asker', models.CharField(max_length=40)),
            ],
        ),
        migrations.AddField(
            model_name='answer',
            name='pointQ',
            field=models.ForeignKey(related_name='answer_question', to='qa_forum.Question'),
        ),
    ]
