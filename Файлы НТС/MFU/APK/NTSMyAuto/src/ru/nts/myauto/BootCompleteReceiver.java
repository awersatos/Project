package ru.nts.myauto;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

public class BootCompleteReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context ctx, Intent action) {
		if (Intent.ACTION_BOOT_COMPLETED.equals(action.getAction())) {
			Intent launcher = new Intent(ctx, MainActivity.class);
			launcher.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			ctx.startActivity(launcher);
			Toast.makeText(ctx, "Starting shell", Toast.LENGTH_SHORT).show();
		}

	}

}
