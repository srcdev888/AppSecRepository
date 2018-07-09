package com.checkmarx.fasterxml;

import com.checkmarx.fasterxml.bank.CurrentAccount;
import com.checkmarx.fasterxml.bike.MountainBike;
import com.checkmarx.fasterxml.transport.Car;
import com.checkmarx.fasterxml.zoo.Animal;
import com.checkmarx.fasterxml.zoo.Cat;
import com.fasterxml.jackson.databind.ObjectMapper;

public class JsonTypeAnnotated {

	// Not vulnerable: nameId or custom used
	public void nameId(String[] args) throws Exception{
		ObjectMapper mapper = new ObjectMapper();
		
		Car car = new Car();
		//car.brand = "toyota";
		car.brand = args[0];
				
		String json = mapper.writeValueAsString(car);
		System.out.println(json);
		
		car = mapper.readValue(json, Car.class);
		System.out.println(car);
	}
	
	// Vulnerable: Class Id used
	public void classId(String[] args) throws Exception{
		ObjectMapper mapper = new ObjectMapper();
		
		Cat cat = new Cat();
		//cat.name = "Fuffy";
		cat.name = args[0];
		cat.likesCream = false;
		cat.lives = 7;
				
		String json = mapper.writeValueAsString(cat);
		System.out.println(json);
		
		Animal expectedCat = mapper.readValue(json, Animal.class);
		System.out.println(expectedCat);
	}
	
	// Vulnerable: Full class Id used
	public void fullClassId(String[] args) throws Exception{
		ObjectMapper mapper = new ObjectMapper();
		
		MountainBike bike = new MountainBike(args[0]);
		
		String json = mapper.writeValueAsString(bike);
		System.out.println(json);
	
		MountainBike expectedBike = mapper.readValue(json, MountainBike.class);
		System.out.println(expectedBike);
	}
	
	// Vulnerable: Minimal class id used
	public void minimalClassId(String[] args) throws Exception{
		ObjectMapper mapper = new ObjectMapper();
		CurrentAccount acct = new CurrentAccount(Integer.parseInt(args[0]));
		
		String json = mapper.writeValueAsString(acct);
		System.out.println(json);
	
		CurrentAccount expectedBike = mapper.readValue(json, CurrentAccount.class);
		System.out.println(expectedBike);
	}
	
	public static void main(String[] args) throws Exception{
		
		JsonTypeAnnotated app = new JsonTypeAnnotated();
		app.nameId(args);
		app.classId(args);
	}
}
