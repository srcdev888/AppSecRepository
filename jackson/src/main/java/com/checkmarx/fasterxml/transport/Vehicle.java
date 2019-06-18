package com.checkmarx.fasterxml.transport;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeInfo.Id;

@JsonTypeInfo(use=Id.NAME)
@JsonSubTypes({
	@JsonSubTypes.Type(value=Car.class, name="Car"),
	@JsonSubTypes.Type(value=Motorbike.class, name="Motorbike")
})
public abstract class Vehicle {

	public String brand;
	public abstract int numOfWheels();
}
