package com.concretepage.blog;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Options;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.SelectProvider;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.jdbc.SQL;

//@Mapper
/**
 * 
 * "@Mapper" optional
 * 
 * Annotated mapper
 * Other service provider "@InsertProvider", "@UpdateProvider", "@DeleteProvider"
 * "org.mybatis.dynamic.sql.select.render.SelectStatementProvider"
 */
public interface BlogMapper {
	
	@Insert("INSERT INTO BLOG(BLOG_NAME, CREATED_ON) VALUES(#{blogName}, #{createdOn})")
	@Options(useGeneratedKeys = true, keyProperty = "blogId")
	public void insertBlog(Blog blog);

	@Select("SELECT BLOG_ID AS blogId, BLOG_NAME as blogName, CREATED_ON as createdOn FROM BLOG WHERE BLOG_ID=#{blogId}")
	public Blog getBlogById(Integer blogId);

	@Results({ @Result(id = true, property = "blogId", column = "BLOG_ID"),
			@Result(property = "blogName", column = "BLOG_NAME"),
			@Result(property = "createdOn", column = "CREATED_ON") })
	@Select("SELECT * FROM BLOG")
	public List<Blog> getAllBlogs();

	@Update("UPDATE BLOG SET BLOG_NAME=#{blogName}, CREATED_ON=#{createdOn} WHERE BLOG_ID=#{blogId}")
	public void updateBlog(Blog blog);

	@Delete("DELETE FROM BLOG WHERE BLOG_ID=#{blogId}")
	public void deleteBlog(Integer blogId);
	
	@Results({ @Result(id = true, property = "blogId", column = "BLOG_ID"),
		@Result(property = "blogName", column = "BLOG_NAME"),	
		@Result(property = "createdOn", column = "CREATED_ON") })
	@SelectProvider(type = BlogSqlBuilder.class, method = "buildGetBlogsByName")
	// renamed parameter name 'PARAM_BLOG_NAME'
	public List<Blog> getBlogsByName(@Param("PARAM_BLOG_NAME") String blogName, @Param("orderByColumn") String orderByColumn);
	
	class BlogSqlBuilder {
		
		  // If not use @Param, you should be define same arguments with mapper method
		  public static String buildGetBlogsByName(final String name, final String orderByColumn) {
		    return new SQL(){{
		      SELECT("*");
		      FROM("BLOG");
		      WHERE("BLOG_NAME like #{PARAM_BLOG_NAME} || '%'");
		      ORDER_BY(orderByColumn);
		    }}.toString();
		  }
		  
		  /*
		  // If use @Param, you can define only arguments to be used
		  public static String buildGetBlogsByName(@Param("orderByColumn") final String orderByColumn) {
			    return new SQL(){{
			      SELECT("*");
			      FROM("BLOG");
			      WHERE("blogName like #{blogName} || '%'");
			      ORDER_BY("blogId");
			    }}.toString();
			  }
		  
		  */
	}
	
	
	
}