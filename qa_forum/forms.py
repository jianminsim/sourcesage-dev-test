from django import forms
from qa_forum.models import Question, Answer


class QuestionForm(forms.ModelForm):
    class Meta:
        model = Question
        exclude = []

# class AnswerForm(forms.ModelForm):
#     class Meta:
#         model = Answer
#         exclude = []
    # forms.Form):
    # asker = forms.CharField(required=True, label='Your Name')
    # title = forms.CharField(required=True, label='Question Title')
    # description = forms.CharField(required=True, label='Please describe your question here...')
    #
    # class Meta:
    #     model = Question
    #     fields = ('asker', 'title', 'description')
    #
    #
    #
