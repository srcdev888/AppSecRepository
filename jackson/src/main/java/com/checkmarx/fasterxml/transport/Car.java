package com.checkmarx.fasterxml.transport;

public class Car extends Vehicle{

	@Override
	public int numOfWheels() {
		return 4;
	}

	@Override
	 public String toString() {
	 return "Car [brand="+brand +", numOfWheels=" + numOfWheels() + "]";
	
	}
}
