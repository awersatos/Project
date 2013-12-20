package ru.nts.myauto;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager.WakeLock;
import android.support.v4.app.NavUtils;
import android.support.v4.app.TaskStackBuilder;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

public class CarProfile extends Activity implements
		IWebServiceCallback, OnItemSelectedListener {

	public static class CarNavigationRecord {
		protected int carID;
		protected String carName;
		protected String deviceID;
		public CarNavigationRecord(int id, String name, String device){
			carID = id;
			carName = name;
			deviceID = device;
		}
		
		public int getID(){
			return carID;
		}
		
		public String getName(){
			return carName;
		}
		
		public String getDeviceID(){
			return deviceID;
		}
		
		@Override
		public String toString(){
			return carName;
		}
	}
	
	private List<CarNavigationRecord> cars;
	private EditText carName;
	private EditText deviceId;
	private Spinner spinnerCars;
	private CarNavigationRecord selectedCar;
	private WakeLock powerLock;


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_car_profile);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            // Show the Up button in the action bar.
            getActionBar().setDisplayHomeAsUpEnabled(true);
        }
		cars = new ArrayList<CarProfile.CarNavigationRecord>();
		carName = (EditText) findViewById(R.id.textCarName);
		deviceId = (EditText) findViewById(R.id.textCarDevice);
		spinnerCars = (Spinner) findViewById(R.id.spinnerCars);
		spinnerCars.setOnItemSelectedListener(this);
	}

	public List<CarNavigationRecord> getCars(){
		return cars;
	}
	
	public EditText getCarNameWidget(){
		return carName;
	}
	
	public EditText getCarDeviceWidget(){
		return deviceId;
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_car_profile, menu);
		return true;
	}

	private int deviceIdToPosition(){
		getServiceProtocol();
		String deviceID = ServiceProtocol.getDeviceID();
		for(int i = 0; i < cars.size(); i++){
			CarNavigationRecord c = cars.get(i);
			if (c.getDeviceID().equals(deviceID)){
				return i;
			}
		}
		return -1;
	}

	@Override
	public void onSuccess(String callType, String callID, String result) {
		if (callType.equals(ServiceProtocol.EVENT_CAR_LIST)){
			if (getServiceProtocol() != null && getServiceProtocol().getResponseObject() != null){
				syncState(getServiceProtocol().getResponseObject());
				Toast.makeText(this, "Список автомобилей загружен", Toast.LENGTH_SHORT).show();	
			} else {
				Toast.makeText(this, "Список автомобилей пуст", Toast.LENGTH_SHORT).show();
			}
			
		}
		
		if (callType.equals(ServiceProtocol.EVENT_REBIND)){
			Toast.makeText(this, "Планшет перепривязан", Toast.LENGTH_SHORT).show();
			doRefresh();
		}
	}

	private void syncState(JSONObject responseObject) {
		try {
			JSONArray arrCars = responseObject.getJSONArray("cars");
			cars.clear();
			int len = arrCars.length();
			for(int i = 0; i < len; i++){
				JSONObject objCar = arrCars.getJSONObject(i);
				int id = objCar.getInt("id");
				String mark = objCar.getString("mark");
				String device = objCar.getString("device_id") == null ? "" : objCar.getString("device_id");
				CarNavigationRecord cnr = new CarNavigationRecord(id, mark, device);
				cars.add(cnr);
			}
			String[] names = new String[cars.size()];
			for(int i = 0; i < cars.size(); i++){
				names[i] = cars.get(i).getName();
			}
			ArrayAdapter<CarNavigationRecord> adapter = new ArrayAdapter<CarNavigationRecord>(this, 
					android.R.layout.simple_spinner_item, 
					cars.toArray(new CarNavigationRecord[0])
					);
	        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
	        spinnerCars.setAdapter(adapter);
			int dpid = deviceIdToPosition();
			if (dpid > -1)
				spinnerCars.setSelection(dpid);
		} catch (JSONException e) {
		}
	}

	@Override
	public void onFault(String callType, String callID, String reason) {
		if (callType.equals(ServiceProtocol.EVENT_CAR_LIST)){
			Toast.makeText(this, "Не удалось загрузить список автомобилей", Toast.LENGTH_SHORT).show();
		}	
		
		if (callType.equals(ServiceProtocol.EVENT_REBIND)){
			Toast.makeText(this, "Не удалось изменить привязку планшета\r\n" + reason, Toast.LENGTH_SHORT).show();
		}
		
	}

	@Override
	public void onResume(){
		super.onResume();
		powerLock = Utility.lockBacklight(this);
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
		getServiceProtocol().registerCallback(this);
		doRefresh();
	}

	private ServiceProtocol getServiceProtocol() {
		return MainActivity.getRegisteredInstance().getServiceProtocol();
	}

	private void doRefresh() {
		Toast.makeText(this, "Запрос списка автомобилей с сервера ...", Toast.LENGTH_SHORT).show();
		getServiceProtocol().getCarList(UUID.randomUUID().toString());
	}
	
	@Override
	public void onPause(){
		super.onPause();
		Utility.unlockBacklight(powerLock);
		getServiceProtocol().unregisterCallback(this);
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    // Handle item selection
	    switch (item.getItemId()) {
	    	case android.R.id.home:
	    		Intent upIntent = NavUtils.getParentActivityIntent(this);
	            if (NavUtils.shouldUpRecreateTask(this, upIntent)) {
	                // This activity is NOT part of this app's task, so create a new task
	                // when navigating up, with a synthesized back stack.
	                TaskStackBuilder.create(this)
	                        // Add all of this activity's parents to the back stack
	                        .addNextIntentWithParentStack(upIntent)
	                        // Navigate up to the closest parent
	                        .startActivities();
	            } else {
	                // This activity is part of this app's task, so simply
	                // navigate up to the logical parent activity.
	                NavUtils.navigateUpTo(this, upIntent);
	            }
	            return true;
	        case R.id.menu_refresh:
	        	doRefresh();
	        	return true;
	        case R.id.menu_rebind_device:
	        	doRebind();
	        	return true;
	        default:
	            return super.onOptionsItemSelected(item);
	    }
	}

	private void doRebind() {
		if (selectedCar != null){
			getServiceProtocol().rebindToCar(UUID.randomUUID().toString(), selectedCar.getID());
		} else {
			Toast.makeText(this, "Не выбран автомобиль для привязки", Toast.LENGTH_SHORT).show();
		}
	}

	@Override
	public void onItemSelected(AdapterView<?> parent, View view, int pos,
			long id) {
		CarNavigationRecord cnr = (CarNavigationRecord) parent.getSelectedItem(); 
		getCarNameWidget().setText(cnr.getName());
		getCarDeviceWidget().setText(cnr.getDeviceID());
		selectedCar = cnr;
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0) {
		deviceId.setText("");
		carName.setText("");
		selectedCar = null;
	}
}
