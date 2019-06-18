package com.checkmarx.fasterxml.transport;

public class Motorbike extends Vehicle{

	@Override
	public int numOfWheels() {
		return 2;
	}
	@Override
	 public String toString() {
	 return "Motorbike [brand="+brand +", numOfWheels=" + numOfWheels() + "]";
	
	}

}
