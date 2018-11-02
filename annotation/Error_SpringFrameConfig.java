package com.checkmarx.test.cors;

/**
 * Issue: @CrossOrigin allows all domain, Best practices is to specifiy attribute
 * 	      e.g., @CrossOrigin(origins = "http://localhost:9000")
 **/
public class Error_SpringFrameConfig {

	@CrossOrigin
	@RestController
	public class ChannelController {

		public void test(){

		}

	}

	@CrossOrigin(origins="*")
	@RestController
	public class AllOriginsController {

		public void test(){

		}

	}


	@CrossOrigin(origins = "http://domain2.com")
	@RestController
	public class DomainOriginsController {

		public void test(){

		}

	}

}
