package ru.nts.myauto;

import android.app.Activity;
import android.content.Context;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;

public class Utility {
	public static final String TAG_BACKLIGHT_LOCK = "ru.nts.myauto.BACKLIGHT_LOCK";
	
	@SuppressWarnings("deprecation")
	public static WakeLock lockBacklight(Activity subject){
		final PowerManager pm = (PowerManager) subject.getSystemService(Context.POWER_SERVICE); 
        PowerManager.WakeLock wl = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK , 
        		TAG_BACKLIGHT_LOCK + "$" + 
        		subject.hashCode() + "@" + 
        		subject.getClass().getName()
        		); 
        wl.acquire(); 
        return wl;
	}
	
	public static void unlockBacklight(WakeLock lock){
		if (lock != null){
			lock.release();
		}
	}

}
