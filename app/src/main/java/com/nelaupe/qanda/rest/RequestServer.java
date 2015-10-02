/**
 * Copyright
 */
package com.nelaupe.qanda.rest;

import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.RequestParams;
import com.loopj.android.http.TextHttpResponseHandler;

import java.lang.reflect.Type;

import bolts.Task;
import cz.msebera.android.httpclient.Header;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
class RequestServer<TSelf> {

    private static final String BASE_URL = "http://qanda.lucas-nelaupe.fr/";
    private static AsyncHttpClient client = new AsyncHttpClient();
    private Type mAnswerType;

    public RequestServer () {

    }

    public RequestServer (TypeToken type) {
        mAnswerType = type.getType();
    }

    public Task<TSelf> doGet(final String url)
    {
        final Task<TSelf>.TaskCompletionSource source = Task.create();
        client.get(getAbsoluteUrl(url), null, new TextHttpResponseHandler() {

            @Override
            public void onSuccess(int statusCode, Header[] headers, String responseString) {
                TSelf response = new GsonBuilder().create().fromJson(responseString, mAnswerType);
                source.trySetResult(response);
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                source.trySetError(new Exception(throwable));
            }

        });
        return source.getTask();
    }


    public Task<Object> doPost(final String url, RequestParams params)
    {
        final Task<Object>.TaskCompletionSource source = Task.create();
        client.post(getAbsoluteUrl(url), params, new TextHttpResponseHandler() {

            @Override
            public void onSuccess(int statusCode, Header[] headers, String responseString) {
                source.trySetResult(null);
            }

            @Override
            public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                source.trySetError(new Exception(throwable));
            }

        });
        return source.getTask();
    }

    private static String getAbsoluteUrl(String relativeUrl) {
        return BASE_URL + relativeUrl;
    }

}
