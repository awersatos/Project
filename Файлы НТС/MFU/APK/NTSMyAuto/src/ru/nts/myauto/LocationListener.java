package ru.nts.myauto;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;

import android.location.Location;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

public class LocationListener implements android.location.LocationListener {
	protected double lon;
	protected double lat;
	protected DecimalFormat df;
	
	public LocationListener(){
		df = new DecimalFormat("#0.000000");
		DecimalFormatSymbols dfs = new DecimalFormatSymbols();
		dfs.setDecimalSeparator(".".charAt(0));
		dfs.setGroupingSeparator((char)0);
		df.setDecimalFormatSymbols(dfs);
	}
	
	@Override
	public void onLocationChanged(Location location) {
		lat = location.getLatitude();
		lon = location.getLongitude();
		Log.i("GPS", df.format(lat) +  "," + df.format(lon));
	}

	@Override
	public void onProviderDisabled(String provider) {

	}

	public Uri getGeoUri(){
		String geoURI = "geo:" + df.format(lat) +  "," + df.format(lon);
		Uri geo = Uri.parse(geoURI);
		return geo;
	}
	
	@Override
	public void onProviderEnabled(String provider) {
		// TODO Auto-generated method stub

	}

	@Override
	public void onStatusChanged(String provider, int status, Bundle extras) {
		// TODO Auto-generated method stub

	}

}
