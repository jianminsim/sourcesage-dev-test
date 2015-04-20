import json
from django.core import serializers
from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.views.decorators.csrf import csrf_exempt
from qa_forum.forms import QuestionForm
from qa_forum.models import Question, Answer


def index(request):
    if request.method == 'POST':
        qform = QuestionForm(request.POST)
        if qform.is_valid():
            qform.save()
    else:
        qform = QuestionForm()


    return render(request, 'index.html', {
        'questions': Question.objects.all().order_by('-created'),
        'qform': qform,
    })

@csrf_exempt
def answer_form(request):
    response = None
    if request.method == 'POST':
        data = json.loads(request.body)
        answer = Answer.objects.create(
            raiser = data['raiser'],
            comment = data['comment'],
            pointQ = Question.objects.get(id=data['pointQ']),
        )
        response = serializers.serialize('json', [answer])
    return HttpResponse(response,
                        content_type='application/json')
