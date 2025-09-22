package examples.pets;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {

    public static String getNowString() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
        return sdf.format(new Date());
    }

    public static long stringToLong(String s) throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
        return sdf.parse(s).getTime();
    }
}