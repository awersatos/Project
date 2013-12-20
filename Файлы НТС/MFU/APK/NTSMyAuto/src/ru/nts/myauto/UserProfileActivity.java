package ru.nts.myauto;

import java.util.UUID;

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
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.Toast;

public class UserProfileActivity extends Activity implements IWebServiceCallback {
	private EditText textSurname;
	private EditText textGivenName;
	private EditText textMiddleName;
	private EditText textPhone1;
	private EditText textPhone2;
	private EditText textPhone3;
	private EditText textBlood;
	private EditText textDiseases;
	private EditText textAllergies;
	private EditText textAddress;
	private WakeLock powerLock;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_user_profile);
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            // Show the Up button in the action bar.
            getActionBar().setDisplayHomeAsUpEnabled(true);
        }
		resolveControls();
	}

	private void resolveControls(){
		textSurname = (EditText)findViewById(R.id.textSurname);
		textGivenName = (EditText)findViewById(R.id.textName);
		textMiddleName = (EditText)findViewById(R.id.textMiddleName);
		textPhone1 = (EditText)findViewById(R.id.textPhone1);
		textPhone2 = (EditText)findViewById(R.id.textPhone2);
		textPhone3 = (EditText)findViewById(R.id.textPhone3);
		textBlood = (EditText)findViewById(R.id.textBlood);
		textDiseases = (EditText)findViewById(R.id.textDeseases);
		textAllergies = (EditText)findViewById(R.id.textAllergies);
		textAddress = (EditText)findViewById(R.id.textAddress);
	}
	
	private void cleanControls(){
		textAddress.setText("");
		textAllergies.setText("");
		textBlood.setText("");
		textDiseases.setText("");
		textGivenName.setText("");
		textMiddleName.setText("");
		textPhone1.setText("");
		textPhone2.setText("");
		textPhone3.setText("");
		textSurname.setText("");
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.activity_user_profile, menu);
		return true;
	}
	
	@Override
	public void onResume(){
		super.onResume();
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);
		getServiceProtocol().registerCallback(this);
		powerLock = Utility.lockBacklight(this);
		doRefresh();
	}

	private ServiceProtocol getServiceProtocol() {
		return MainActivity.getRegisteredInstance().getServiceProtocol();
	}

	private void doRefresh() {
		cleanControls();
		Toast.makeText(this, "Запрос анкеты с сервера ...", Toast.LENGTH_SHORT).show();
		getServiceProtocol().getUserProfile(UUID.randomUUID().toString());
	}
	
	@Override
	public void onPause(){
		super.onPause();
		Utility.unlockBacklight(powerLock);
		getServiceProtocol().unregisterCallback(this);
	}

	private void decodeBloodType(JSONObject profile){
		String bloodCode = "";
		String rhesus = "Rh";
		String bloodText = "";
		try {
			int bgCode = profile.getInt("blood_group");
			int rfCode = profile.getInt("blood_factor");
			switch (bgCode){
				case 1:
					bloodCode = "0 (I) ";
					bloodText = "первая ";
					break;
				case 2:
					bloodCode = "A (II) ";
					bloodText = "вторая ";
					break;
				case 3:
					bloodCode = "B (III) ";
					bloodText = "третья ";
					break;
				case 4:
					bloodCode = "AB (IV) ";
					bloodText = "четвертая ";
					break;
				default:
					bloodCode = "";
					bloodText = "неустановленная; ";
					break;
			}
			switch(rfCode){
				case 0:
					rhesus += "-";
					bloodText += "резус-отрицательная";
					break;
				case 1:
					rhesus += "+";
					bloodText += "резус-положительная";
					break;
				default:
					rhesus = "";
					bloodText += "резус-фактор неизвестен";
			}
			textBlood.setText(bloodCode + rhesus + " [" + bloodText + "]");
		} catch (JSONException e) {

		}
	}
	
	private void fillControls(JSONObject source){
		try {
			JSONObject profile = source.getJSONObject("profile");
			decodeBloodType(profile);
			textAddress.setText(profile.getString("address"));
			textAllergies.setText(profile.getString("allergy"));
			textDiseases.setText(profile.getString("systemic_diseases"));
			textGivenName.setText(profile.getString("name"));
			textMiddleName.setText(profile.getString("patronymic"));
			textPhone1.setText(profile.getString("phone1"));
			textPhone2.setText(profile.getString("phone2"));
			textPhone3.setText(profile.getString("phone3"));
			textSurname.setText(profile.getString("surname"));
		} catch (JSONException e) {

		}
	}
	
	@Override
	public void onSuccess(String callType, String callID, String result) {
		if (callType.equals(ServiceProtocol.EVENT_USER_PROFILE)){
			if (getServiceProtocol() != null && getServiceProtocol().getResponseObject() != null){
				fillControls(getServiceProtocol().getResponseObject());
				Toast.makeText(this, "Анкета загружена", Toast.LENGTH_SHORT).show();	
			} else {
				Toast.makeText(this, "Анкета не заполнена", Toast.LENGTH_SHORT).show();
			}
			
		}
	}

	@Override
	public void onFault(String callType, String callID, String reason) {
		if (callType.equals(ServiceProtocol.EVENT_USER_PROFILE)){
			Toast.makeText(this, "Не удалось отобразить анкету", Toast.LENGTH_SHORT).show();
		}		
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
	        default:
	            return super.onOptionsItemSelected(item);
	    }
	}
}
