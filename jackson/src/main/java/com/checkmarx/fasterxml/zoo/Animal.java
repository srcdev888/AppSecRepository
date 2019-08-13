package com.checkmarx.fasterxml.zoo;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.JsonTypeInfo.Id;

//If possible USE “type name” and NOT classname as type id: 
@JsonTypeInfo(use=Id.CLASS)
public abstract class Animal {
	public String name;
}