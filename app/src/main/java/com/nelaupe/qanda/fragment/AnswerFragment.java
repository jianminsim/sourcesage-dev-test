/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import com.mobilesolutionworks.android.util.ViewUtils;
import com.nelaupe.qanda.R;
import com.nelaupe.qanda.entity.Answer;
import com.nelaupe.qanda.entity.Question;
import com.nelaupe.qanda.rest.RequestAPI;

import java.util.ArrayList;
import java.util.List;

import bolts.Continuation;
import bolts.Task;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class AnswerFragment extends BaseFragment {

    private Question mQuestion;
    private Task<List<Answer>> mLoader;
    private RequestAPI mRequestAPI;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle args = getArguments();

        if (args == null || !args.containsKey("data")) {
            activity().getFragmentManager().popBackStack();
            return;
        }

        mQuestion = (Question) args.getSerializable("data");
        mRequestAPI = new RequestAPI();

        mLoader = mRequestAPI.getAnswersOf(mQuestion);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.answer_fragment, container, false);
    }

    @Override
    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        if (mQuestion == null) {
            // Pop back stack is async. Prevent loading the view
            return;
        }

        RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(getActivity());
        mRecyclerView.setLayoutManager(mLayoutManager);

        final AnswerAdapter mAdapter = new AnswerAdapter();
        mRecyclerView.setAdapter(mAdapter);

        String author = mQuestion.author + " ";
        ViewUtils.vuSetText(view, author, R.id.user);
        ViewUtils.vuSetText(view, mQuestion.title, R.id.question_name);
        ViewUtils.vuSetText(view, DateUtils.getRelativeTimeSpanString(mQuestion.date.getTime()).toString(), R.id.date);

        final EditText answerEditText = ViewUtils.vuFind(view, R.id.answer);
        ImageButton button = ViewUtils.vuFind(view, R.id.submit);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(!TextUtils.isEmpty(answerEditText.getText())) {
                    final String answer = answerEditText.getText().toString();
                    answerEditText.setText("");

                    AlertDialog.Builder builder = new AlertDialog.Builder(activity(), R.style.MyAlertDialogStyle);
                    builder.setTitle(R.string.app_name);
                    builder.setMessage("Sending ...");
                    final AlertDialog loadingDialog = builder.show();

                     mRequestAPI.postAnswerOf(mQuestion, answer).continueWith(new Continuation<Answer, Object>() {
                         @Override
                         public Object then(Task<Answer> task) throws Exception {
                             loadingDialog.dismiss();
                             if(task.isCompleted() && !task.isFaulted()) {
                                 mAdapter.add(task.getResult());
                             } else {
                                 AlertDialog.Builder builder = new AlertDialog.Builder(activity(), R.style.MyAlertDialogStyle);
                                 builder.setTitle(R.string.app_name);
                                 builder.setMessage("An error occurred.");
                                 builder.setPositiveButton("OK", null);
                                 builder.show();
                             }

                             return task;
                         }
                     });
                }
            }
        });


        mLoader.continueWith(new Continuation<List<Answer>, Object>() {
            @Override
            public Object then(Task<List<Answer>> task) throws Exception {
                mAdapter.addAll(task.getResult());
                return null;
            }
        });

    }

    public static class AnswerViewHolder extends RecyclerView.ViewHolder {
        protected TextView vContent;

        public AnswerViewHolder(View v) {
            super(v);
            vContent = (TextView) v.findViewById(R.id.answer);
        }
    }

    public class AnswerAdapter extends RecyclerView.Adapter<AnswerViewHolder> {

        private List<Answer> mAnswer;

        public AnswerAdapter() {
            this.mAnswer = new ArrayList<>();
        }

        public AnswerAdapter(List<Answer> answers) {
            if (answers == null) {
                this.mAnswer = new ArrayList<>();
            } else {
                this.mAnswer = answers;
            }
        }

        public void addAll(List<Answer> answers) {
            mAnswer.clear();
            mAnswer.addAll(answers);
            notifyDataSetChanged();
        }

        public void add(Answer answers) {
            mAnswer.add(answers);
            notifyDataSetChanged();
        }

        @Override
        public int getItemCount() {
            return mAnswer.size();
        }

        @Override
        public void onBindViewHolder(AnswerViewHolder answerViewHolder, int i) {
            Answer answer = mAnswer.get(i);
            answerViewHolder.vContent.setText(answer.content);
        }

        @Override
        public AnswerViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            View itemView = LayoutInflater.
                    from(viewGroup.getContext()).
                    inflate(R.layout.cell_answer, viewGroup, false);

            return new AnswerViewHolder(itemView);
        }

    }

}
