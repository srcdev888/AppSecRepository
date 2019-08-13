package com.ssrf.ok;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.springframework.http.HttpEntity;

import sun.net.www.http.HttpClient;

public class TheadSSRFHook {

	public static void main(String[] args) {

		try {
			// hook
			SecurityUtil.startSSRFNetHookChecking();
			HttpClient client = HttpClients.createDefault();
			//String urlNameString = "http://www.cainiao-inc.com";
			String urlNameString = args[0];
			HttpGet get = new HttpGet(urlNameString);
			HttpResponse response = client.execute(get);
			HttpEntity entity = response.getEntity();
			System.out.println("run success");
		} catch (IOException e2) {
			System.out.println("fetch error 1");
		} catch (SSRFUnsafeConnectionError e) {
			System.out.println("fetch error 2");
		} finally {
			System.out.println("finally");
			// ֹͣhook
			SecurityUtil.stopSSRFNetHookChecking();
		}
	}

}
