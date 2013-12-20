package ru.nts.myauto;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.telephony.TelephonyManager;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class ServiceProtocol {
	public static class TrackableResponseHandler extends AsyncHttpResponseHandler {
		private String callid;
		private String calltype;
		private ServiceProtocol owner;
		private JSONObject responseObject;
		
		public void setCallID(String value){
			callid = value;
		}
		
		public void setCallType(String value){
			calltype = value;
		}
		
		public void setOwner(ServiceProtocol value){
			owner = value;
		}
		
		@Override
		public void onSuccess(String response){
			try {
				JSONObject obj = new JSONObject(response);
				responseObject = obj;
				if (owner != null)
					owner.response = obj;
				if(obj.getInt("error") == 0){	
					if (owner != null)
						owner.callbackSuccess(calltype, callid, response);
				} else {
					if (owner != null)
						owner.callbackFailure(calltype, callid, response);
				}
			} catch (JSONException e) {
				responseObject = null;
				if (owner != null)
					owner.callbackFailure(calltype, callid, e.toString());
			}
			
		}
		
		@Override
		public void onFailure(Throwable reason){
			if (owner != null)
				owner.callbackFailure(calltype, callid, reason.toString());
		}
		
		public JSONObject getResponse(){
			return responseObject;
		}
	}
	public static String URL_WEBSERVICE = "http://avtoblackbox.com:31273/api/";
	public static String OP_LOGIN = "login";
	public static String OP_CALLBACK = "callOperator";
	public static String OP_CAR_LIST = "carList";
	public static String OP_ASSIGN_DEVICE = "assignDevice";
	public static String OP_RESOLVE_DEVICE = "getCarByDevice";
	public static String OP_USER_PROFILE = "viewProfile";
	
	public static String PARAM_USERNAME = "login";
	public static String PARAM_PASSWORD = "password";
	public static String PARAM_AUTH_TOKEN = "token";
	public static String PARAM_DEVICE_ID = "device_id";
	public static String PARAM_CAR_ID = "car_id";
	public static String EVENT_AUTH = "AUTHENTICATION";
	public static String EVENT_CALL = "CALLBACK";
	public static String EVENT_REBIND = "REBIND";
	public static String EVENT_RESOLVE = "RESOLVE";
	public static String EVENT_CAR_LIST = "CAR_LIST";
	public static String EVENT_USER_PROFILE = "USER_PROFILE";
	
	protected String baseUrl;
	protected JSONObject response;
	protected String auth_token;
	protected AsyncHttpClient client;
	protected List<IWebServiceCallback> callbacks;
	
	public static String getDeviceID(){
		TelephonyManager tm = (TelephonyManager) MainActivity.getRegisteredInstance().getSystemService(Context.TELEPHONY_SERVICE);

	    String tmDevice, androidId;
	    tmDevice = "" + tm.getDeviceId();
	    androidId = "" + android.provider.Settings.Secure.getString(MainActivity.getRegisteredInstance().getContentResolver(), android.provider.Settings.Secure.ANDROID_ID);
	    return tmDevice + "-" + androidId;
	}
	
	public ServiceProtocol(String baseURL){
		baseUrl = baseURL;
		client = new AsyncHttpClient();
		callbacks = new ArrayList<IWebServiceCallback>();
	}
	
	public ServiceProtocol(){
		this(URL_WEBSERVICE);
	}
	
	public String getBaseUrl(){
		return baseUrl;
	}
	
	public void setBaseUrl(String value){
		baseUrl = value;
	}
	
	public synchronized void registerCallback(IWebServiceCallback callback){
		if (callbacks.indexOf(callback) == -1){
			callbacks.add(callback);
		}
	}
	
	public synchronized void unregisterCallback(IWebServiceCallback callback){
		if (callbacks.indexOf(callback) != -1){
			callbacks.remove(callback);
		}
	}
	
	public boolean isAuthenticated(){
		return auth_token != null && auth_token.trim().length() > 0;
	}
	
	public void authenticate(String login, String password){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_USERNAME, login);
		rp.put(PARAM_PASSWORD, password);
		client.post(baseUrl + OP_LOGIN, rp, 
				new AsyncHttpResponseHandler(){
					@Override
					public void onSuccess(String response){
						try {
							JSONObject obj = new JSONObject(response);
							if(obj.getInt("error") == 0){	
								String token = obj.getString("token");
								auth_token = token;
								callbackSuccess(EVENT_AUTH, "0", auth_token);
							} else {
								callbackFailure(EVENT_AUTH, "0", "Authentication failed");
							}
						} catch (JSONException e) {
							callbackFailure(EVENT_AUTH, "0", e.toString());
						}
						
					}
					
					@Override
					public void onFailure(Throwable reason){
						callbackFailure(EVENT_AUTH, "0", reason.toString());
					}
				}
		);
	}
	
	public void requestOperatorCallback(String id){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_AUTH_TOKEN, auth_token);
		rp.put(PARAM_DEVICE_ID, getDeviceID());
		TrackableResponseHandler h = new TrackableResponseHandler(); 
		h.setCallType(EVENT_CALL);
		h.setCallID(id);
		h.setOwner(this);
		client.post(baseUrl + OP_CALLBACK, rp, h);
	}
	
	public void rebindToCar(String id, int carID){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_AUTH_TOKEN, auth_token);
		rp.put(PARAM_DEVICE_ID, getDeviceID());
		rp.put(PARAM_CAR_ID, Integer.toString(carID));
		TrackableResponseHandler h = new TrackableResponseHandler(); 
		h.setCallType(EVENT_REBIND);
		h.setCallID(id);
		h.setOwner(this);
		client.post(baseUrl + OP_ASSIGN_DEVICE, rp, h);
	}

	public void resolveCar(String id){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_AUTH_TOKEN, auth_token);
		rp.put(PARAM_DEVICE_ID, getDeviceID());
		TrackableResponseHandler h = new TrackableResponseHandler(); 
		h.setCallType(EVENT_RESOLVE);
		h.setCallID(id);
		h.setOwner(this);
		client.post(baseUrl + OP_RESOLVE_DEVICE, rp, h);
	}
	
	public void getUserProfile(String id){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_AUTH_TOKEN, auth_token);
		TrackableResponseHandler h = new TrackableResponseHandler(); 
		h.setCallType(EVENT_USER_PROFILE);
		h.setCallID(id);
		h.setOwner(this);
		client.post(baseUrl + OP_USER_PROFILE, rp, h);
	}
	
	public void getCarList(String id){
		RequestParams rp = new RequestParams();
		rp.put(PARAM_AUTH_TOKEN, auth_token);
		TrackableResponseHandler h = new TrackableResponseHandler(); 
		h.setCallType(EVENT_CAR_LIST);
		h.setCallID(id);
		h.setOwner(this);
		client.post(baseUrl + OP_CAR_LIST, rp, h);
	}
	
	protected void callbackSuccess(String callType, String callID, String result){
		Log.d("ServiceProtocol", "SUCCESS : " + callType + "/" + callID + "\r\n" + result);
		for (IWebServiceCallback callback : callbacks){
			callback.onSuccess(callType, callID, result);
		}
	}
	
	protected void callbackFailure(String callType, String callID, String reason){
		Log.w("ServiceProtocol", "FAILURE : " + callType + "/" + callID + "\r\n" + reason);
		for (IWebServiceCallback callback : callbacks){
			callback.onFault(callType, callID, reason);
		}
	}
	
	public void setToken(String value){
		auth_token = value;
	}
	
	public JSONObject getResponseObject(){
		return response;
	}
}
