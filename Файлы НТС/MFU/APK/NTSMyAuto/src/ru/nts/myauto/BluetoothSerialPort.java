package ru.nts.myauto;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.UUID;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.util.Log;

public class BluetoothSerialPort {
	public static final UUID UUID_SERIAL_PORT_PROFILE = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB");
                                                                       //00001101-0000-1000-8000-00805F9B34FB
	
	private static final Map<String, BluetoothSerialPort> instances = new HashMap<String, BluetoothSerialPort>();
	protected String mac;
	protected UUID service;
	protected BluetoothDevice device;
	protected BluetoothSocket socket;
	protected InputStream in;
	protected OutputStream out;
	
	protected String faultDescription;
	protected byte[] buffer;
	
	public static synchronized void reset(){
		Iterator<String> keys = instances.keySet().iterator();
		while(keys.hasNext()){
			String key = keys.next();
			BluetoothSerialPort sp = instances.get(key);
			instances.remove(key);
			if (sp.isConnected()){
				sp.disconnect();
			}
		}
	}
	
	public static synchronized BluetoothSerialPort get(String mac){
		return get(mac, UUID_SERIAL_PORT_PROFILE);
	}
	
	public static synchronized BluetoothSerialPort get(String mac, UUID service){
		String epid = mac + "/" + service.toString().toUpperCase();
		BluetoothSerialPort btspp = instances.get(epid);
		if (btspp == null){
			btspp = new BluetoothSerialPort(mac, service);
			instances.put(epid, btspp);
		}
		return btspp;
	}
	
	public static BluetoothSocket getBluetoothSocket(BluetoothDevice device, int port) 
               throws NoSuchMethodException, IllegalArgumentException, 
                      IllegalAccessException, InvocationTargetException{
	    	Log.d("BluetoothSerialPort", device.getName() + " " + device.getAddress() + " get socket on port " + port);
    		Method m = device.getClass().getMethod("createRfcommSocket", new Class[] { int.class });
	    	return (BluetoothSocket) m.invoke(device, port);
    }
	
	public BluetoothSerialPort(String macAddress, UUID serviceID){
		mac = macAddress;
		service = serviceID;
		buffer = new byte[1024];
	}
	
	public boolean connect(){
		Log.d("BluetoothSerialPort", "Connecting " + mac + "/" + service);
		faultDescription = null;
		if (BluetoothAdapter.getDefaultAdapter() == null){
			faultDescription = "Bluetooth adapters absent";
			Log.w("BluetoothSerialPort", faultDescription);
			return false;
		}
		
		if (!BluetoothAdapter.getDefaultAdapter().isEnabled()){
			faultDescription = "Bluetooth adapter disabled";
			Log.w("BluetoothSerialPort", faultDescription);
			return false;
		}
		
		if (device == null){
			device = BluetoothAdapter.getDefaultAdapter().getRemoteDevice(mac);
		}
		Log.d("BluetoothSerialPort", "Remote device " + mac + " is " + device != null ? device.getName() : "null" );
		
		if (socket == null){
			try {
				Log.d("BluetoothSerialPort", "Performing secure RFCOMM link ...");
				socket = device.createRfcommSocketToServiceRecord(service);
				BluetoothAdapter.getDefaultAdapter().cancelDiscovery();
				socket.connect();
				Log.d("BluetoothSerialPort", "--> Secure link established");
			} catch (IOException e){
				Log.w("BluetoothSerialPort", e);
				Log.d("BluetoothSerialPort", "Performing insecure RFCOMM link ...");
				try {
					socket = device.createInsecureRfcommSocketToServiceRecord(service);
					socket.connect();
					Log.d("BluetoothSerialPort", "--> Insecure link established");
				} catch (IOException e1){
					Log.w("BluetoothSerialPort", e1);
					faultDescription = "Cannot connect to " + mac;
					device = null;
					socket = null;
					return false;
				}
			}
		}
		
		Log.d("BluetoothSerialPort", "Obtaining streams for socket");
		try {
			in = socket.getInputStream();
		} catch (IOException e) {
			Log.w("BluetoothSerialPort", e);
			faultDescription = "Cannot obtain input stream for " + mac + "/" + service.toString();
			device = null;
			socket = null;
			in = null;
			return false;
		}
		
		try {
			out = socket.getOutputStream();
		} catch (IOException e) {
			Log.w("BluetoothSerialPort", e);
			faultDescription = "Cannot obtain output stream for " + mac + "/" + service.toString();
			device = null;
			socket = null;
			in = null;
			out = null;
			return false;
		}
		Log.d("BluetoothSerialPort", "Initializing I/O");
		Log.d("BluetoothSerialPort", "RFCOMM OK");
		return true;
	}
	
	public void disconnect(){
		Log.d("BluetoothSerialPort", "Disconnecting " + mac + "/" + service);
		if (in != null){
			try {
				in.close();
			} catch (IOException e) {
				Log.w("BluetoothSerialPort", e);
			}
		}
		in = null;
		
		if (out != null){
			try {
				out.close();
			} catch (IOException e) {
				Log.w("BluetoothSerialPort", e);
			}
		}
		out = null;
		
		if (socket != null){
			try {
				socket.close();
			} catch (IOException e) {
				Log.w("BluetoothSerialPort", e);
			}
		}
		socket = null;
		Log.d("BluetoothSerialPort", "Disconnected");
	}
	
	public boolean hasIncomingData(){
		try {
			return in.available() > 0;
		} catch (IOException e) {
			Log.w("BluetoothSerialPort", e);
			return false;
		}
	}
	
	public byte[] read(){
		if (hasIncomingData()){
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			int rs = -1;
			do {
				try {
					rs = in.read(buffer, 0, Math.min(buffer.length, in.available()));
				} catch (IOException e) {
					break;
				}
				if (rs > 0){
					baos.write(buffer, 0, rs);
				}
			} while (rs > 0 && hasIncomingData());
			try {
				baos.close();
			} catch (IOException e) {
				return null;
			}
			return baos.toByteArray();
		} else {
			return null;
		}
	}
	
	public boolean write(byte[] data){
		if (out != null){
			try {
				out.write(data);
				out.flush();
				return true;
			} catch (IOException e) {
				return false;
			}
		}	
		return false;
	}
	
	public String readLine(){
		if (hasIncomingData()){
			try {
				byte[] data = read();
				if (data != null){
					return new String(data, "windows-1251");
				}
			} catch (IOException e) {
				return null;
			}
		}
		return null;
	}
	
	public boolean writeLine(String line){
		try {
			return write((line + "\r\n").getBytes("UTF-8"));
		} catch (UnsupportedEncodingException e) {
			return false;
		}
	}
	
	public boolean writeLine(String line, String charset){
		try {
			return write((line + "\r\n").getBytes(charset));
		} catch (UnsupportedEncodingException e) {
			return false;
		}
	}
	
	public String getFaultDescription(){
		return faultDescription;
	}
	
	public String getMAC(){
		return mac;
	}
	
	public UUID getServiceUUID(){
		return service;
	}
	
	public boolean isConnected(){
		return socket != null && socket.isConnected();
	}
	
	public BluetoothSocket getSocket(){
		return socket;
	}
}
