/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nelaupe.qanda.R;
import com.nelaupe.qanda.entity.Answer;
import com.nelaupe.qanda.entity.Question;
import com.nelaupe.qanda.entity.User;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class MainFragment extends BaseFragment {

    private QuestionAdapter mAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.main_fragment, container, false);
    }

    @Override
    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        FloatingActionButton fab = (FloatingActionButton) view.findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                navigationFragmentHandler().pushContent(new AnswerFragment());
            }
        });

        RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(getActivity());
        mRecyclerView.setLayoutManager(mLayoutManager);

        mAdapter = new QuestionAdapter(fetchData());
        mRecyclerView.setAdapter(mAdapter);

    }

    private List<Question> fetchData() {
//        Fetch from server later.
//        Dummy data

        ArrayList<Question> result = new ArrayList<>();

        for (int i = 0; i < 50; i++) {
            Question question = new Question();
            question.id = i;
            question.title = "What do you think of this app so far ?";
            question.user = new User();
            question.user.username = "Lucas";
            question.date = new Date();
            question.answers = new ArrayList<>();

            Answer answer = new Answer();
            answer.id = 0;
            answer.content = "I Like it";

            question.answers.add(answer);
            result.add(question);
        }

        return result;
    }

    public class QuestionAdapter extends RecyclerView.Adapter<QuestionViewHolder> {

        private List<Question> mQuestions;

        public QuestionAdapter(List<Question> questions) {
            this.mQuestions = questions;
        }

        @Override
        public int getItemCount() {
            return mQuestions.size();
        }

        @Override
        public void onBindViewHolder(QuestionViewHolder questionViewHolder, int i) {
            Question question = mQuestions.get(i);
            questionViewHolder.vTitle.setText(question.title);
            questionViewHolder.vUser.setText(question.user.username);
            questionViewHolder.vDate.setText(DateUtils.getRelativeTimeSpanString(question.date.getTime()));
        }

        @Override
        public QuestionViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
            View itemView = LayoutInflater.
                    from(viewGroup.getContext()).
                    inflate(R.layout.cell_question, viewGroup, false);
            return new QuestionViewHolder(itemView);
        }

        public Question getData(int position) {
            return mQuestions.get(position);
        }

    }

    public class QuestionViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        protected TextView vTitle;
        protected TextView vUser;
        protected TextView vDate;

        public QuestionViewHolder(View v) {
            super(v);
            v.setOnClickListener(this);
            vTitle = (TextView) v.findViewById(R.id.title);
            vUser = (TextView) v.findViewById(R.id.user);
            vDate = (TextView) v.findViewById(R.id.date);
        }

        @Override
        public void onClick(View v) {
            AnswerFragment answerFragment = new AnswerFragment();
            Bundle args = new Bundle();
            args.putSerializable("data", mAdapter.getData(getAdapterPosition()));
            navigationFragmentHandler().pushContent(answerFragment, args);
        }

    }
}
