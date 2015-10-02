/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mobilesolutionworks.android.util.ViewUtils;
import com.nelaupe.qanda.R;
import com.nelaupe.qanda.entity.Answer;
import com.nelaupe.qanda.entity.Question;

import java.util.List;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class AnswerFragment extends BaseFragment {

    private Question mQuestion;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle args = getArguments();

        if(args == null || !args.containsKey("data")) {
            navigationFragmentHandler().popCurrentFragment();
            return;
        }

        mQuestion = (Question) args.getSerializable("data");
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.answer_fragment, container, false);
    }

    @Override
    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(getActivity());
        mRecyclerView.setLayoutManager(mLayoutManager);

        AnswerAdapter mAdapter = new AnswerAdapter(mQuestion.answers);
        mRecyclerView.setAdapter(mAdapter);

        ViewUtils.vuSetText(view, mQuestion.user.username, R.id.user);
        ViewUtils.vuSetText(view, mQuestion.title, R.id.title);
        ViewUtils.vuSetText(view, DateUtils.getRelativeTimeSpanString(mQuestion.date.getTime()).toString(), R.id.date);
    }

    public class AnswerAdapter extends RecyclerView.Adapter<AnswerViewHolder> {

        private List<Answer> mAnswer;

        public AnswerAdapter(List<Answer> answers) {
            this.mAnswer = answers;
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

    public static class AnswerViewHolder extends RecyclerView.ViewHolder {
        protected TextView vContent;

        public AnswerViewHolder(View v) {
            super(v);
            vContent =  (TextView) v.findViewById(R.id.answer);
        }
    }

}
