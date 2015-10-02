/**
 * Copyright
 */
package com.nelaupe.qanda.lib;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.provider.Settings;
import android.telephony.TelephonyManager;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 * Created with IntelliJ
 * Created by Lucas Nelaupe
 * Date 26/03/15
 */
public class ToolsFormat {

    public static Date convertServerDate(String data) {
        try {
            return new SimpleDateFormat("yyyy-MM-dd hh:mm:ss", Locale.ENGLISH).parse(data);
        } catch (ParseException e) {
            return null;
        }
    }

    public static String formatDate(String pattern, Date date) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern, Locale.ENGLISH);
        return simpleDateFormat.format(date);
    }

    public static String formatNumberUS(int number) {
        DecimalFormat formatter = new DecimalFormat("#,###,###");
        return formatter.format(number);
    }

    public static String setDecimalDigitAnyway(int digit, double value) {
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.US);
        nf.setMinimumFractionDigits(digit);
        nf.setMaximumFractionDigits(digit);
        nf.setRoundingMode(RoundingMode.HALF_EVEN);
        nf.setGroupingUsed(true);
        return nf.format(value);
    }

    public static String getNumberSuffix(int n) {
        if (n >= 11 && n <= 13) {
            return "th";
        }

        switch (n % 10) {
            case 1:
                return "st";
            case 2:
                return "nd";
            case 3:
                return "rd";
            default:
                return "th";

        }
    }

    public static File BitmapToFileJPG(Context context, Bitmap bitmap, String name) throws IOException {

        //create a file to write bitmap data
        File f = new File(context.getCacheDir(), name);
        f.createNewFile();

        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos);
        byte[] bitmapdata = bos.toByteArray();

        //write the bytes in file
        FileOutputStream fos = new FileOutputStream(f);
        fos.write(bitmapdata);
        fos.flush();
        fos.close();

        return f;
    }

    public static Bitmap createScaledImage(Bitmap bitmap) {

        final int maxSize = 1000;
        int outWidth;
        int outHeight;
        int inWidth = bitmap.getWidth();
        int inHeight = bitmap.getHeight();
        if (inWidth > inHeight) {
            outWidth = maxSize;
            outHeight = (inHeight * maxSize) / inWidth;
        } else {
            outHeight = maxSize;
            outWidth = (inWidth * maxSize) / inHeight;
        }

        return Bitmap.createScaledBitmap(bitmap, outWidth, outHeight, false);

    }

    public static Bitmap fileToBitmap(File file) {
        String filePath = file.getPath();
        return BitmapFactory.decodeFile(filePath);
    }


    public static String getUniqueID(Context context) {
        String myAndroidDeviceId;
        TelephonyManager mTelephony = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        if (mTelephony.getDeviceId() != null) {
            myAndroidDeviceId = mTelephony.getDeviceId();
        } else {
            myAndroidDeviceId = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        }
        return myAndroidDeviceId;
    }

}
