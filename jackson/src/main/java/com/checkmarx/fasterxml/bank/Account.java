package com.checkmarx.fasterxml.bank;

import com.fasterxml.jackson.annotation.JsonTypeInfo;

@JsonTypeInfo(use=JsonTypeInfo.Id.MINIMAL_CLASS)
public class Account {
	
	public Account(int number) {
		this.number = number;
	}
	
	private int number;
	public int getNumber() {
		return this.number;
	}
}
