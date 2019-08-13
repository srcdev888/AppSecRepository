package com.checkmarx.fasterxml.bike;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(use=JsonTypeInfo.Id.CLASS)
public abstract class Bicycle {

	public String brand;
	public String getBrand() {
		return brand;
	}
	
	
}

