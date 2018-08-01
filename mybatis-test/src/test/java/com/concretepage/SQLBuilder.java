package com.concretepage;

import org.apache.ibatis.jdbc.SQL;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

public class SQLBuilder{
	
	@Before
	public void before() {}
	
	@After
	public void after() {}
	
	@BeforeClass
	public static void beforeClass() {}
	
	@AfterClass
	public static void afterClass() {}
	
	@Ignore
	@Test
	public void testSelectPersonSql() {
		System.out.println(selectPersonSql());
	}
	
	@Test
	public void testSelectPersonLike() {
		System.out.println(selectPersonLike("id", "first", "last", "abc"));
	}
	
	
	private String selectPersonSql() {
		  return new SQL() {{
		    SELECT("P.ID, P.USERNAME, P.PASSWORD, P.FULL_NAME");
		    SELECT("P.LAST_NAME, P.CREATED_ON, P.UPDATED_ON");
		    FROM("PERSON P");
		    FROM("ACCOUNT A");
		    INNER_JOIN("DEPARTMENT D on D.ID = P.DEPARTMENT_ID");
		    INNER_JOIN("COMPANY C on D.COMPANY_ID = C.ID");
		    WHERE("P.ID = A.ID");
		    WHERE("P.FIRST_NAME like ?");
		    OR();
		    WHERE("P.LAST_NAME like ?");
		    GROUP_BY("P.ID");
		    HAVING("P.LAST_NAME like ?");
		    OR();
		    HAVING("P.FIRST_NAME like ?");
		    ORDER_BY("P.ID");
		    ORDER_BY("P.FULL_NAME");
		  }}.toString();
		}
	
	// With conditionals (note the final parameters, required for the anonymous inner class to access them)
	public String selectPersonLike(final String id, final String firstName, final String lastName, final String strVar) {
	  return new SQL() {{
	    SELECT("P.ID, P.USERNAME, P.PASSWORD, P.FIRST_NAME, P.LAST_NAME");
	    FROM("PERSON P");
	    if (id != null) {
	      WHERE("P.ID like #{id}");
	    }
	    if (firstName != null) {
	      WHERE("P.FIRST_NAME like #{firstName}");
	    }
	    if (lastName != null) {
	      WHERE("P.LAST_NAME like #{lastName}");
	    }
	    if (strVar != null) {
		     WHERE("P.STRVAR = "+strVar);
		}
	    
	    ORDER_BY("P.LAST_NAME");
	  }}.toString();
	}
}