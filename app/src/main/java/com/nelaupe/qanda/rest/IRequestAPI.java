/**
 * Copyright
 */
package com.nelaupe.qanda.rest;

import com.nelaupe.qanda.entity.Answer;
import com.nelaupe.qanda.entity.Question;

import java.util.List;

import bolts.Task;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public interface IRequestAPI {

    // GET

    Task<List<Question>> getQuestions();

    Task<List<Answer>> getAnswersOf(Question question);

    // POST

    Task<Answer> postAnswerOf(Question question, String answer);

    Task<Question> postQuestion(String author, String question);
}
