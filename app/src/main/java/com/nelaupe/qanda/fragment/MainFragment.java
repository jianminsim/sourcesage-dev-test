/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.gson.reflect.TypeToken;
import com.nelaupe.qanda.R;
import com.nelaupe.qanda.entity.Question;
import com.nelaupe.qanda.rest.RequestServer;

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

        RequestServer<List<Question>> requestServer = new RequestServer<>(new TypeToken<List<Question>>(){}); // Stupid java
        mLoader = requestServer.doLoad("questions");
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

        mAdapter = new QuestionAdapter();
        mRecyclerView.setAdapter(mAdapter);

        mLoader.continueWith(new Continuation<List<Question>, Object>() {
            @Override
            public Object then(Task<List<Question>> task) throws Exception {
                mAdapter.addAll(task.getResult());
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
            mQuestions.clear();
            mQuestions.addAll(questions);
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
}
