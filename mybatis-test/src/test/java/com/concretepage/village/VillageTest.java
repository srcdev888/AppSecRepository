package com.concretepage.village;

import java.io.Reader;
import java.nio.charset.Charset;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.concretepage.BaseDataTest;
import com.concretepage.SqlSessionFactoryManager;
import com.concretepage.user.User;
import com.concretepage.village.Village;
import com.concretepage.village.VillageDAO;

/**
 * MyBatis: Mapping via Id
 */
public class VillageTest {

	private static VillageDAO villageDAO;

	protected static SqlSessionFactory sqlSessionFactory;

	@BeforeClass
	public static void beforeClass() throws Exception {

		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		Charset charset = Resources.getCharset();
		try {
			// make sure that the SQL file has been saved in UTF-8!
			Resources.setCharset(Charset.forName("utf-8"));
			BaseDataTest.runScript(sqlSessionFactory.getConfiguration().getEnvironment().getDataSource(),
					"com/concretepage/village/Village.sql");
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			Resources.setCharset(charset);
		}

	}

	@AfterClass
	public static void afterClass() {
	}

	@Before
	public void before() {
		villageDAO = new VillageDAO();
	}

	@After
	public void after() {
		villageDAO = null;
	}

	@Test
	public void testGetAllVillages() {

		// Select all
		List<Village> villages = villageDAO.getAll();
		for (Village v : villages) {
			System.out.println(v.toString());
		}

	}

	@Test
	public void testInsertVillage() {

		// insert
		Village village = new Village();
		village.setName("Crossing Republic");
		village.setDistrict("Ghaziabad");
		village.setCountry("Africa");
		villageDAO.save(village);
		Assert.assertTrue(village.getId() != 0);
		System.out.println("---Data saved---");
		System.out.println(village.toString());
	}
	
	@Test
	public void testUpdateVillage() {
		// update
		Village village = new Village();
		village.setId(0);
		village.setName("Dhananjaypur");
		village.setDistrict("Varanasi");
		village.setCountry("Africa");
		villageDAO.update(village);
		System.out.println("---Data updated---");
	}
	
	@Test
	public void testGetVillageById() {
		// select
		Village village = villageDAO.getVillage(2);
		System.out.println(village.toString());
		Assert.assertNotNull(village);
	}
	
	@Ignore
	@Test
	public void testGetVillageByName() {
		// SQL injection: select by name
		List<Village> villages = villageDAO.getVillageByName("1' OR '1'='1");
		Assert.assertNotNull(villages);
	}
	
	@Test
	public void testGetVillageByDistrictAndCountry() {
		
		LocationDataEntity locationDataEntity = new LocationDataEntity();
		locationDataEntity.setCountry("sg");
		locationDataEntity.setDistrict("east");
		
		List<Village> villages = villageDAO.getVillageByCountryAndDistrict(locationDataEntity);
		Assert.assertNotNull(villages);
		Assert.assertEquals(1, villages.size());
		
	}
	
	
	@Test
	public void testDeleteVillageById() {
		// delete
		villageDAO.delete(4);
		System.out.println("---Data deleted---");
		
		Village deletedVillage = villageDAO.getVillage(4);
		Assert.assertNull(deletedVillage);
	}

}
