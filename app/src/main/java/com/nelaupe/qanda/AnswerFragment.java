/**
 * Copyright
 */
package com.nelaupe.qanda;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nelaupe.qanda.entity.Answer;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class AnswerFragment extends Fragment {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.answer_layout, container, false);
    }

    @Override
    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        RecyclerView mRecyclerView = (RecyclerView) view.findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(getActivity());
        mRecyclerView.setLayoutManager(mLayoutManager);

        QuestionAdapter mAdapter = new QuestionAdapter(fetchData());
        mRecyclerView.setAdapter(mAdapter);

    }

    private List<Answer> fetchData() {
//        Fetch from server later.
//        Dummy data

        ArrayList<Answer> result = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            Answer answer = new Answer();
            answer.id = i;
            answer.content = "I Like";
            result.add(answer);
        }

        return result;
    }

    public class QuestionAdapter extends RecyclerView.Adapter<AnswerViewHolder> {

        private List<Answer> mAnswer;

        public QuestionAdapter(List<Answer> answers) {
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
