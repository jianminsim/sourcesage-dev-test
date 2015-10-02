/**
 * Copyright
 */
package com.nelaupe.qanda.rest;

import com.google.gson.reflect.TypeToken;
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

    @Override
    public Task<List<Question>> getQuestions() {
        RequestServer<List<Question>> requestServer = new RequestServer<>(new TypeToken<List<Question>>(){}); // Stupid java
        return requestServer.doLoad("questions");
    }

    @Override
    public Task<List<Answer>> getAnswersOf(Question question) {
        RequestServer<List<Answer>> requestServer = new RequestServer<>(new TypeToken<List<Question>>(){}); // Stupid java
        return requestServer.doLoad("questions/"+question.id+"/answers");
    }

}
