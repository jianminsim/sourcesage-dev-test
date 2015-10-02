/**
 * Copyright
 */
package com.nelaupe.qanda.rest;

import com.google.gson.reflect.TypeToken;
import com.loopj.android.http.RequestParams;
import com.nelaupe.qanda.entity.Answer;
import com.nelaupe.qanda.entity.Question;

import java.util.List;

import bolts.Task;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class RequestAPI implements IRequestAPI {

    // GET

    @Override
    public Task<List<Question>> getQuestions() {
        RequestServer<List<Question>> requestServer = new RequestServer<>(new TypeToken<List<Question>>(){}); // Stupid java
        return requestServer.doGet("questions");
    }

    @Override
    public Task<List<Answer>> getAnswersOf(Question question) {
        RequestServer<List<Answer>> requestServer = new RequestServer<>(new TypeToken<List<Answer>>(){}); // Stupid java
        return requestServer.doGet("questions/" + question.id + "/answers");
    }

    // POST

    @Override
    public Task<Object> postAnswerOf(Question question, String answer) {
        RequestServer<Object> requestServer = new RequestServer<>();

        RequestParams params = new RequestParams();
        params.put("questionId", question.id);
        params.put("content", answer);

        return requestServer.doPost("answers", params);
    }

}
