/**
 * Copyright
 */
package com.nelaupe.qanda.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * Created with IntelliJ
 * Created by lucas
 * Date 26/03/15
 */
public class Question implements Serializable {

    public long id;

    public String author;

    public String title;

    public Date date;

}
