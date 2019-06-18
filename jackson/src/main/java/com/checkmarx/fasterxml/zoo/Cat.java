package com.checkmarx.fasterxml.zoo;

public class Cat extends Animal {

	public boolean likesCream;
	public int lives;

	@Override
	public String toString() {
		return "Cat [name=" + name + ", likesCream=" + likesCream + ", lives=" + lives + "]";
	}
}