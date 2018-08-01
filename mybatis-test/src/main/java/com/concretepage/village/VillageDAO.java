package com.concretepage.village;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.concretepage.SqlSessionFactoryManager;

/**
 * Mapper by id in XML configuration
 * 
 */
public class VillageDAO {
	
	/**
	 * Base package for mapper, test for string concatenation
	 */
	private static String base_package = "com.concretepage.village.VillageMapper";
	
	public void save(Village village){
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  session.insert("com.concretepage.village.VillageMapper.insertVillage", village);
	  session.commit();
	  session.close();
	}
	public void update(Village village){
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  session.update("com.concretepage.village.VillageMapper.updateVillage", village);
	  session.commit();
	  session.close();
	}
	public void delete(Integer id){
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  session.delete("com.concretepage.village.VillageMapper.deleteVillage", id);
	  session.commit();
	  session.close();
	}
	public Village getVillage(Integer id) {
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  Village village = session.selectOne(base_package+".selectVillage", id);
	  session.close();
	  return village;
	}
	
	public List<Village> getVillageByName(String name) {
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  List<Village> villages = session.selectList("com.concretepage.village.VillageMapper.selectVillageByName", name);
	  session.close();
	  return villages;
	}
	
	public List<Village> getVillageByCountryAndDistrict(LocationDataEntity locationDataEntity) {
	  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
	  List<Village> villages = session.selectList(
			  "com.concretepage.village.VillageMapper.selectVillageByCountryAndDistrict", 
			  locationDataEntity);
	  session.close();
	  return villages;
	}
	
	public List<Village> getAll(){
		SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();	
		return session.selectList("com.concretepage.village.VillageMapper.selectVillages");
	}
}
