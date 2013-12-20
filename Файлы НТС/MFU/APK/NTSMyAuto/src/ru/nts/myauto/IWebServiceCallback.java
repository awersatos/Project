package ru.nts.myauto;

public interface IWebServiceCallback {
	void onSuccess(String callType, String callID, String result);
	void onFault(String callType, String callID, String reason);
}
