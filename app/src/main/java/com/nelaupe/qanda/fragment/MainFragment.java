/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nelaupe.qanda.R;
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
public class MainFragment extends BaseFragment {

    private QuestionAdapter mAdapter;
    private Task<List<Question>> mLoader;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mLoader =  new RequestAPI().getQuestions();
        mAdapter = new QuestionAdapter();
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

                AskFragment askFragment = new AskFragment();
                askFragment.setTargetFragment(MainFragment.this, R.id.post_new_question);
                navigationFragmentHandler().pushContent(askFragment);
            }
        });

        final RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(getActivity());
        mRecyclerView.setLayoutManager(mLayoutManager);

        mRecyclerView.setAdapter(mAdapter);

        mLoader.continueWith(new Continuation<List<Question>, Object>() {
            @Override
            public Object then(Task<List<Question>> task) throws Exception {
                mAdapter.addAll(task.getResult());
                task.getResult().clear();
                return null;
            }
        });

    }

    public class QuestionAdapter extends RecyclerView.Adapter<QuestionViewHolder> {

        private List<Question> mQuestions;

        public QuestionAdapter() {
            this.mQuestions = new ArrayList<>();
        }

        public QuestionAdapter(List<Question> questions) {
            this.mQuestions = questions;
        }

        public void addAll(List<Question> questions) {
            mQuestions.addAll(questions);
            notifyDataSetChanged();
        }

        public void add(Question question) {
            mQuestions.add(question);
            notifyDataSetChanged();
        }

        @Override
        public int getItemCount() {
            return mQuestions.size();
        }

        @Override
        public void onBindViewHolder(QuestionViewHolder questionViewHolder, int i) {
            Question question = mQuestions.get(i);
            questionViewHolder.vTitle.setText(question.title);
            questionViewHolder.vUser.setText(question.author);
//            questionViewHolder.vDate.setText(DateUtils.getRelativeTimeSpanString(question.date.getTime()));
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


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);

        switch (requestCode) {
            case R.id.post_new_question: {
                if (resultCode == Activity.RESULT_OK) {
                    Question question = (Question) intent.getSerializableExtra("data");
                    mAdapter.add(question);
                }
                break;
            }
        }
    }

}
