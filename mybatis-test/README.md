# MyBatis Vulnerable Example
* Author:   Pedric Kng
* Updated:  01 August 2018

***

## MyBatis Framework
MyBatis is a fork of iBatis since 2012; java persistence framework, iBatis has been discontinued since the birth of MyBatis

This example was build on the latest Version 3.4.6 (March 11, 2018)

### Includes
The example illustrates;
* [XML-based Configuration and/or Mapper](src/main/java/com/concretepage/village)

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.concretepage.village.VillageMapper">

	<resultMap id="villageResult" type="village">
		<id property="id" column="id" />
		<result property="name" column="name" />
		<result property="district" column="district" />
	</resultMap>

  <select id="selectVillage" resultType="village" parameterType="int"
		resultMap="villageResult">
		SELECT id, name, district from village WHERE id = #{id}
	</select>

	<select id="selectVillage2" resultType="village" parameterType="String"
		resultMap="villageResult">
		SELECT id, name, district from village WHERE name like '${_parameter}'
	</select>
...
</mapper>
```

```java
public class VillageDAO {
private static String base_package = "com.concretepage.village.VillageMapper";

public void save(Village village){
  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
  session.insert("com.concretepage.village.VillageMapper.insertVillage", village);
  session.commit();
  session.close();
}

public Village getVillage(Integer id) {
  SqlSession session = SqlSessionFactoryManager.getSqlSessionFactory().openSession();
  Village village = session.selectOne(base_package+".selectVillage", id);
  session.close();
  return village;
}
```

* [Java API Mapper](src/main/java/com/concretepage/user)

```XML
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace='com.concretepage.user.UserMapper'>

  <select id='getUserById' parameterType='int' resultType='com.concretepage.user.User'>
     SELECT
      user_id as "userId",
      email_id as "emailId",
      password as "password",
      first_name as "firstName",
      last_name as "lastName"
     FROM users
     WHERE user_id = #{userId}
  </select>

  <select id='getAllUsers' resultMap='UserResult'>
   SELECT * FROM users
  </select>

  <insert id='insertUser' parameterType='User' useGeneratedKeys='true' keyProperty='userId'>
   INSERT INTO users(email_id, password, first_name, last_name)
    VALUES(#{emailId}, #{password}, #{firstName}, #{lastName})
  </insert>

```

```Java
public interface UserMapper {

	public User getUserById(Integer userId);

	public void insertUser(User user);

 	public List<User> getAllUsers();

	public void updateUser(User user);

	public void deleteUser(Integer userId);

}
```

* [Dynamic SQL (not to be confused with MyBatis Dynamic SQL)](src/main/java/com/concretepage/village)

```XML
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.concretepage.village.VillageMapper">
…
	<!-- 通用查询结果列-->
	<sql id="Base_Column_List">
		 id, name, district, country
	</sql>

	<!-- Vulnerable Queries -->
	<!-- Mixed usage of 'include' and 'dynamic sql' -->
	<select id="selectVillageByCountryAndDistrict"
		parameterType="com.concretepage.village.LocationDataEntity"
		resultMap="villageResult">
		SELECT
		<include refid="Base_Column_List" />
		FROM village
		<where>
			<if test="country != null ">
				 AND country like #{country}
			</if>
			<if test="district != null ">
				 AND district like '${district}'
			</if>
		</where>
	</select>
</mapper>
```

* [Java Annotation (Lack in flexibility and capabilities)](src/main/java/com/concretepage/blog)

```Java
public interface BlogMapper {

	@Insert("INSERT INTO BLOG(BLOG_NAME, CREATED_ON) VALUES(#{blogName}, #{createdOn})")
	@Options(useGeneratedKeys = true, keyProperty = "blogId")
	public void insertBlog(Blog blog);

	@Select("SELECT BLOG_ID AS blogId, BLOG_NAME as blogName, CREATED_ON as createdOn FROM BLOG WHERE BLOG_ID=#{blogId}")
	public Blog getBlogById(Integer blogId);
}
```

### Vulnerabilities
MyBatis is vulnerable to SQL injection due to sql concatenation function using '$', illustrated in the example;
* [UserMapper :: getUserByFirstname](src/main/resources/com/concretepage/user/UserMapper.xml)
* [VillageMapper :: selectVillageByName](src/main/resources/com/concretepage/village/VillageMapper.xml)
* [VillageMapper :: selectVillageByCountryAndDistrict](src/main/resources/com/concretepage/village/VillageMapper.xml)


### References
MyBatis Official Website [[1]]  
Fixing SQL Injection in MyBatis [[2]]  
Dynamic SQL [[3]]  


[1]:http://www.mybatis.org/ "MyBatis Official Website"
[2]:https://software-security.sans.org/developer-how-to/fix-sql-injection-in-java-mybatis "Fixing SQL Injection in MyBatis"
[3]:http://www.mybatis.org/mybatis-3/dynamic-sql.html "Dynamic SQL"
