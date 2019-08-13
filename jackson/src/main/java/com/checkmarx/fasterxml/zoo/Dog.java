package com.checkmarx.fasterxml.zoo;

public class Dog extends Animal {

	public double barkVolume;

	@Override
	public String toString() {
		return "Dog [name=" + name + ", barkVolume=" + barkVolume + "]";
	}
}