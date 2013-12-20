package ru.nts.myauto;

import java.util.UUID;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.PackageManager;
import android.graphics.drawable.Drawable;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.PowerManager.WakeLock;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

public class MainActivity extends Activity  implements IStatusMessageListener, IWebServiceCallback {
	static class BluetoothMonitor implements Runnable{
		BluetoothSerialPort btspp;
		IStatusMessageListener callback;
		String mac;
		String line = null;
		Activity context;
		Thread monitor;
		boolean active;
		
		public BluetoothMonitor(Activity parent){
			context = parent;
		}
		
		public void setCallback(IStatusMessageListener owner){
			callback = owner;
			
		}
		@Override
		public void run() {
			while (active){
				try {
					doCallback("Connecting to " + mac + " ...");
					if (btspp != null && !btspp.isConnected()){
						btspp.connect();
					}

					Log.d("BT_IO", btspp.getMAC() + " connected");
					doCallback("Connected to " + mac + ". OK");
					if (btspp.hasIncomingData()) {
						line = btspp.readLine();
					} else { 
						Log.d("BT_IO", "No data available");
						line = null;
					}

					Log.d("BT_IO", "readed : " + line);
					if (line != null && !line.trim().equalsIgnoreCase("")){
						if (line.indexOf("\r\n") > -1){
							String[] lines = line.split("\r\n");
							for(String le : lines){
								doCallback(le);
							}
						} else {
							doCallback(line);
						}
					}
					Thread.sleep(1000);
					Log.d("BT_IO", "Ping device");
					doCallback("Send ping ...");
					btspp.writeLine("PLANSHET", "windows-1251");
					Thread.sleep(1000);
				} catch (Throwable t){
					Log.w("BT_IO", "Exception :" + t);
					try {
						btspp.disconnect();
						Thread.sleep(1000);
					} catch (InterruptedException e) {
					}
				} finally {
					doCallback("  ");
				}
			}
			if (btspp != null){
					btspp.disconnect();
			}
			active = false;
			monitor = null;
		}
		
		public void start(String btmac){
			if (!isRunning()){
				mac = btmac;
				active = true;
				btspp = BluetoothSerialPort.get(mac);
				monitor = new Thread(this);
				monitor.start();
			}
		}
		
		public void stop(){
			active = false;
			if (monitor != null){
				try {
					monitor.join();
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		public boolean isRunning(){
			return monitor != null && monitor.isAlive();
		}
		
		private void doCallback(String data){
			final String xfer = data;
			if (callback != null && context != null && data != null){
				Runnable action = new Runnable() {
					@Override
					public void run() {
						callback.onSignal(xfer);
						
					}
				};
				context.runOnUiThread(action);
			}
		}

		public BluetoothSerialPort getPort() {
			// TODO Auto-generated method stub
			return btspp;
		}
		
	}
	
	private static final String SKYPE_PACKAGE = "com.skype.raider";
	private static final String SKYPE_ACTIVITY_MAIN = "com.skype.raider.Main";
	private static final String TORQUE_FREE_PACKAGE = "org.prowl.torquefree";
	private static final String TORQUE_PACKAGE = "org.prowl.torque";
	private static final String CAMCORDER_PACKAGE = "dadny.recorder.lite.google";
	// settings
	public static final String SETTINGS_KEY_TOKEN = "settings.auth_token";
	public static final String SETTINGS_KEY_MAC = "settings.btpeer.mac";
	public static final String SETTINGS_KEY_USERNAME = "settings.username";
	public static final String SETTINGS_KEY_PASSWORD = "settings.password";
	public static final String SETTINGS_KEY_SERVICE = "settings.web.service";
    // Intent request codes
    private static final int REQUEST_CONNECT_DEVICE_SECURE = 1;
    private static final int REQUEST_CONNECT_DEVICE_INSECURE = 2;
    private static final int REQUEST_ENABLE_BT = 3;
    
    private static MainActivity instance;
    
	private LocationManager lm;
	private String token;
	private String mac;
	private String login;
	private String password;
	private String serviceURL;
	private BluetoothAdapter bluetoothAdapter;
	private BluetoothMonitor bluetoothMonitor;
	private SharedPreferences preferences;
	private ServiceProtocol protocol;
	private ImageButton btnCancel;
	private TextView viewBalance;
	private WakeLock powerLock;
	private boolean alert = false;

	public static MainActivity getRegisteredInstance(){
		return instance;
	}
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
        btnCancel = (ImageButton)findViewById(R.id.buttonMyAvto);
        viewBalance = (TextView) findViewById(R.id.textBalance);
        protocol = new ServiceProtocol();
        if (instance == null){
        	instance = this;
        }
	}

	private void authorizeWebService(){
		if (!protocol.isAuthenticated()){
			if (login != null && !login.equals("") && password != null && !password.equals("")) {
				Toast.makeText(this, "Авторизация пользователя " + login, Toast.LENGTH_SHORT).show();
				protocol.authenticate(login, password);
			} else {
				Toast.makeText(this, "АВТОРИЗАЦИЯ НЕВОЗМОЖНА! НЕ НАСТРОЕНА УЧЕТНАЯ ЗАПИСЬ!" + login, Toast.LENGTH_SHORT).show();
			}
		} else {
			Toast.makeText(this, "Авторизация в веб-сервисе подтверждена", Toast.LENGTH_SHORT).show();
		}
	}
	
	@Override
	protected void onResume(){
		super.onResume();
		powerLock = Utility.lockBacklight(this);
		protocol.registerCallback(this);
		activateLocation();
        loadPreferences();
        setBackgroundColors();
        if (serviceURL != "" && !serviceURL.trim().equals("")){
        	protocol.setBaseUrl(serviceURL);
        }
        authorizeWebService();
        if (checkBluetooth() && !mac.equals("")){
        	connectDevice(mac);
        }
        //getWindow().setBackgroundDrawableResource(R.drawable.logo);
	}

	private void setBackgroundColors() {
		//ImageButton cbib = (ImageButton)findViewById(R.id.buttonOperator);
        //ImageButton btib = (ImageButton)findViewById(R.id.buttonBluetooth);
        //cbib.setBackgroundColor(Color.rgb(0xFF, 0x88, 0x88));
        //btib.setBackgroundColor(Color.rgb(0x88, 0x88, 0xFF));
	}

	private void activateLocation() {
		if (lm == null) {
        	lm = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        }
	}

	private void loadPreferences() {
		if(preferences == null){
        	//preferences = getSharedPreferences(PREFS_NAME, MODE_WORLD_READABLE | MODE_WORLD_WRITEABLE);
        	preferences = PreferenceManager.getDefaultSharedPreferences(this);
        }		
        token = preferences.getString(SETTINGS_KEY_TOKEN, "");
        mac = preferences.getString(SETTINGS_KEY_MAC, "");
        login = preferences.getString(SETTINGS_KEY_USERNAME, "demo3");
        password = preferences.getString(SETTINGS_KEY_PASSWORD, "123456");
        serviceURL = preferences.getString(SETTINGS_KEY_SERVICE, ServiceProtocol.URL_WEBSERVICE);
	}
	
	@Override
	protected void onPause(){
		super.onPause();
		Utility.unlockBacklight(powerLock);
		protocol.unregisterCallback(this);
		savePreferences();
		stopBluetoothMonitor();
	}

	private void stopBluetoothMonitor() {
		if (bluetoothMonitor != null && bluetoothMonitor.isRunning()){
			bluetoothMonitor.stop();
		}
	}

	private void savePreferences() {
		Editor e = preferences.edit();
		e.putString(SETTINGS_KEY_MAC, mac);
		e.putString(SETTINGS_KEY_TOKEN, token);
		e.putString(SETTINGS_KEY_SERVICE, serviceURL);
		e.putString(SETTINGS_KEY_USERNAME, login);
		e.putString(SETTINGS_KEY_PASSWORD, password);
		e.commit();
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_main, menu);
		
		return true;
	}
 
	public void doCallOperator(View view){
		protocol.requestOperatorCallback(UUID.randomUUID().toString());
	}
	
	public void showUserProfile(View view){
		Intent sai = new Intent(this, UserProfileActivity.class);
    	startActivity(sai);
	}
	
	public void onMyAvto(View view){
		if (alert){
			BTI_sendCancelCommand(view);
		} else {
			showCarProfile(view);
		}
	}
	
	public void showCarProfile(View view){
		Intent sai = new Intent(this, CarProfile.class);
    	startActivity(sai);
	}
	
	public void showSkype(View view){
		// Make sure the Skype for Android client is installed
		  if (!isPackageInstalled(SKYPE_PACKAGE)) {
			  openMarket(SKYPE_PACKAGE);
			  return;
		  }
		  Uri skypeUri = Uri.parse("");
		  Intent myIntent = new Intent(Intent.ACTION_VIEW, skypeUri);

		  myIntent.setComponent(new ComponentName(SKYPE_PACKAGE, SKYPE_ACTIVITY_MAIN));
		  myIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		  startActivity(myIntent);
	}
	
	public void showCamcorder(View view){
		if (!launchPackage(CAMCORDER_PACKAGE)){
			openMarket(CAMCORDER_PACKAGE);
		}
	}
	
	public void showDiag(View view){
		if (launchPackage(TORQUE_PACKAGE)){
			return; 
		} else if (launchPackage(TORQUE_FREE_PACKAGE)){
			return;
		} else {
			openMarket(TORQUE_FREE_PACKAGE);
		}
	}
	
	public void showWebBrowser(View view){
		Intent intent = new Intent();
	    intent.setClass(this, MainActivity.class);
	 
		Intent browser = new Intent(Intent.ACTION_VIEW, Uri.parse("about:blank"));
		startActivity(browser);
	}
	
	public void showMedia(View view){
		Intent intent = new Intent(Intent.ACTION_PICK);
		intent.setType("audio/*");
		intent.setType("video/*");
		intent.setData(android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
		startActivity(intent);
	}
	
	public void showNavigator(View view){
		LocationListener ll = new LocationListener();
		lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0,
		            0, ll);
		Uri geo = ll.getGeoUri();
		Intent geoMap = new Intent(Intent.ACTION_VIEW, geo);
		startActivity(geoMap);
		lm.removeUpdates(ll);
	}
	
	
	public void showBluetooth(View view){
		checkBluetooth();
		resetBluetooth();
		ensureBluetoothPeer();
	}

	public boolean checkBluetooth(){
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (bluetoothAdapter == null){
			Toast toast = Toast.makeText(getApplicationContext(), "Bluetooth adapter absent on this device", Toast.LENGTH_LONG);
	        toast.setGravity(Gravity.CENTER, 0, 0);
	        toast.show();
	        return false;
		} else {
			if (!bluetoothAdapter.isEnabled()) {
				Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
	            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
	            return false;
	        }
		}		
		return true;
	} 
	
	public void resetBluetooth(){
		mac = "";
	}
	
	public boolean ensureBluetoothPeer(){
		if (mac.equals("")){
            Intent serverIntent = new Intent(this, DeviceListActivity.class);
            startActivityForResult(serverIntent, REQUEST_CONNECT_DEVICE_SECURE);
            return false;
		} else {
			connectDevice(mac);
		}
		return true;
	}
	
	public void BTI_sendCancelCommand(View view){
		if (bluetoothMonitor != null && bluetoothMonitor.getPort() != null){
			Log.d("BT_IO", "sending STOP command");
			bluetoothMonitor.getPort().writeLine("STOP", "windows-1251");
		}
	}
	
	public boolean isPackageInstalled(String packageID) {
		  PackageManager pm = this.getPackageManager();
		  try {
			  pm.getPackageInfo(packageID, PackageManager.GET_ACTIVITIES);
		  }
		  catch (PackageManager.NameNotFoundException e) {
			  return (false);
		  }
		  return (true);
	}
	
	public void openMarket(String packageID) {
		try{
			  Uri marketUri = Uri.parse("market://details?id=" + packageID);
			  Intent myIntent = new Intent(Intent.ACTION_VIEW, marketUri);
			  myIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			  startActivity(myIntent);
		} catch(Exception e){
			Uri marketUri = Uri.parse("https://play.google.com/store/apps/details?id=" + packageID);
			Intent myIntent = new Intent(Intent.ACTION_VIEW, marketUri);
			myIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(myIntent);
		}
	  return;
	}
	
	public boolean launchPackage(String packageID){
		PackageManager pm = getPackageManager();
		try {
			pm.getPackageInfo(packageID, PackageManager.GET_ACTIVITIES);
			startActivity(pm.getLaunchIntentForPackage(packageID));
			return true;
		} catch (PackageManager.NameNotFoundException e) {
		   return false; 
		}
	}

	@Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
		Log.d("onActivityResult", "RequestCode : " + Integer.toString(requestCode));
		Log.d("onActivityResult", "ResultCode  : " + Integer.toString(resultCode));
		Log.d("onActivityResult", "Intent      : " + data);
        switch (requestCode) {
        case REQUEST_CONNECT_DEVICE_SECURE:
            // When DeviceListActivity returns with a device to connect
            if (resultCode == Activity.RESULT_OK) {
                connectDevice(data, true);
            }
            break;
        case REQUEST_CONNECT_DEVICE_INSECURE:
            // When DeviceListActivity returns with a device to connect
            if (resultCode == Activity.RESULT_OK) {
                connectDevice(data, false);
            }
            break;
        case REQUEST_ENABLE_BT:
            // When the request to enable Bluetooth returns
            if (resultCode == Activity.RESULT_OK) {
                // Bluetooth is now enabled, so set up a chat session
                Toast.makeText(this, "Bluetooth enabled", Toast.LENGTH_SHORT).show();
            } else {
                // User did not enable Bluetooth or an error occurred
                Toast.makeText(this, "Bluetooth activation failure", Toast.LENGTH_SHORT).show();
                finish();
            }
        }
    }

    private void connectDevice(Intent data, boolean secure) {
        // Get the device MAC address
        String address = data.getExtras()
            .getString(DeviceListActivity.EXTRA_DEVICE_ADDRESS);
        Log.d("BT_IO", "Device address : " + address);
        // Get the BluetoothDevice object
        connectDevice(address);
    }
    
    private void connectDevice(String address){
    	BluetoothDevice device = bluetoothAdapter.getRemoteDevice(address);
        Log.d("BT_IO", "Device : " + device);
        mac = address;
        savePreferences();
        stopBluetoothMonitor();
		Log.d("BT_IO", "Starting monitor");
        startBluetoothMonitor(address);
	
    }

	private void startBluetoothMonitor(String address) {
		if (bluetoothMonitor == null) {
			bluetoothMonitor = new BluetoothMonitor(this);
			bluetoothMonitor.setCallback(this);
		}
        bluetoothMonitor.start(address);
	}
    
    @Override
    public void onSignal(String signalID){
    	Log.d("BT_IO", "Signal : " + signalID);
    	if (signalID.equalsIgnoreCase("STATUS:NORMAL")){
    		viewBalance.setText("Статус: ОК");
    		alert = false;
    		btnCancel.setBackgroundResource(R.drawable.myauto);
    	} else if (signalID.equalsIgnoreCase("BLACK BOX CONNECT OK")){
    		viewBalance.setText("Устройство подключено");
    		alert = false;
    		btnCancel.setBackgroundResource(R.drawable.myauto);
    	} else if (signalID.startsWith("STATUS:ALARM")) {
    		int sec = Integer.parseInt(signalID.substring(12));
    		viewBalance.setText("СРАБАТЫВАНИЕ УСТРОЙСТВА! " + sec + " секунд осталось!");
    		btnCancel.setBackgroundResource(R.drawable.myauto_red);
    		alert = true;
    	} else {
    		viewBalance.setText(signalID);
    	}
    }

	@Override
	public void onSuccess(String callType, String callID, String result) {
		if (callType.equalsIgnoreCase(ServiceProtocol.EVENT_AUTH)){
			Toast.makeText(this, "Авторизация на сервере пройдена", Toast.LENGTH_SHORT).show();
			token = result;
			savePreferences();
		}
		
		if (callType.equalsIgnoreCase(ServiceProtocol.EVENT_CALL)){
			Toast.makeText(this, "Заявка на вызов отправлена", Toast.LENGTH_SHORT).show();
		}
		
	}

	@Override
	public void onFault(String callType, String callID, String reason) {
		if (callType.equalsIgnoreCase(ServiceProtocol.EVENT_AUTH)){
			Toast.makeText(this, "Авторизация на сервере не пройдена\r\nПроверьте и исправьте данные учетной записи", Toast.LENGTH_SHORT).show();
			token = "";
			savePreferences();
		}
		
		if (callType.equalsIgnoreCase(ServiceProtocol.EVENT_CALL)){
			Toast.makeText(this, "ВОЗНИКЛА ОШИБКА! Заявка на вызов НЕ ОТПРАВЛЕНА!", Toast.LENGTH_SHORT).show();
		}
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    // Handle item selection
	    switch (item.getItemId()) {
	    	case android.R.id.home:
	    		return super.onOptionsItemSelected(item);
	        case R.id.menu_settings:
	        	Intent sai = new Intent(this, SettingsActivity.class);
	        	startActivity(sai);
	        	return true;
	        default:
	            return super.onOptionsItemSelected(item);
	    }
	}
	
	public ServiceProtocol getServiceProtocol(){
		return protocol;
	}
	
}
