/**
 * Copyright
 */
package com.nelaupe.qanda.entity;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class Question implements Serializable {

    public long id;

    public User user;

    public String title;

    public Date date;

    public ArrayList<Answer> answers;

}
