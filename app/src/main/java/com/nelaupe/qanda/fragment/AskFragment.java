/**
 * Copyright
 */
package com.nelaupe.qanda.fragment;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.mobilesolutionworks.android.util.ViewUtils;
import com.nelaupe.qanda.R;
import com.nelaupe.qanda.entity.Question;
import com.nelaupe.qanda.rest.RequestAPI;

import bolts.Continuation;
import bolts.Task;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class AskFragment extends BaseFragment {

    private RequestAPI mRequestAPI;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mRequestAPI = new RequestAPI();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.ask_fragment, container, false);
    }

    @Override
    public void onViewCreated(final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        final EditText usernameEditText = ViewUtils.vuFind(view, R.id.username);
        final EditText questionEditText = ViewUtils.vuFind(view, R.id.question);

        Button button = ViewUtils.vuFind(view, R.id.submit);
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                if(!TextUtils.isEmpty(usernameEditText.getText()) && !TextUtils.isEmpty(questionEditText.getText())) {
                    final String username = usernameEditText.getText().toString();
                    final String question = questionEditText.getText().toString();
                    usernameEditText.setText("");
                    questionEditText.setText("");

                    mRequestAPI.postQuestion(username, question).continueWith(new Continuation<Question, Object>() {
                        @Override
                        public Object then(Task<Question> task) throws Exception {

                            if(task.isCompleted()) {
                                navigationFragmentHandler().popCurrentFragment();
                            } else {
                                // Error
                            }

                            return task;
                        }
                    });
                }
            }
        });

    }

}
