package com.nelaupe.qanda;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.nelaupe.qanda.entity.Question;
import com.nelaupe.qanda.entity.User;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });

        RecyclerView mRecyclerView = (RecyclerView) findViewById(R.id.my_recycler_view);
        mRecyclerView.setHasFixedSize(true);

        LinearLayoutManager mLayoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(mLayoutManager);

        QuestionAdapter mAdapter = new QuestionAdapter(fetchData());
        mRecyclerView.setAdapter(mAdapter);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
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

    }

    public static class QuestionViewHolder extends RecyclerView.ViewHolder {
        protected TextView vTitle;
        protected TextView vUser;
        protected TextView vDate;

        public QuestionViewHolder(View v) {
            super(v);
            vTitle =  (TextView) v.findViewById(R.id.title);
            vUser = (TextView)  v.findViewById(R.id.user);
            vDate = (TextView)  v.findViewById(R.id.date);
        }
    }

}