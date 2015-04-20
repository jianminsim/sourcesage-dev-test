from django import forms
from qa_forum.models import Question, Answer


class QuestionForm(forms.ModelForm):
    class Meta:
        model = Question
        exclude = []

