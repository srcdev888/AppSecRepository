package com.concretepage.blog;

import java.nio.charset.Charset;
import java.util.Date;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import com.concretepage.BaseDataTest;
import com.concretepage.SqlSessionFactoryManager;

/**
 * MyBatis: Mapping via annotation
 */
public class BlogServiceTest {

	private static BlogService blogService;

	@BeforeClass
	public static void setup() throws Exception {
		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		Charset charset = Resources.getCharset();
		try {
			// make sure that the SQL file has been saved in UTF-8!
			Resources.setCharset(Charset.forName("utf-8"));
			BaseDataTest.runScript(sqlSessionFactory.getConfiguration().getEnvironment().getDataSource(),
					"com/concretepage/blog/blog.sql");
		}catch(Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			Resources.setCharset(charset);
		}
	}

	@AfterClass
	public static void teardown() {}
	
	@Before
	public void before() {
		blogService = new BlogService();
	}
	
	@After
	public void after() {
		blogService = null;
	}
	
	@Test
	public void testGetBlogById() {
		Blog blog = blogService.getBlogById(1);
		Assert.assertNotNull(blog);
		System.out.println(blog);
	}

	
	@Test
	public void testGetAllBlogs() {
		List<Blog> blogs = blogService.getAllBlogs();
		Assert.assertNotNull(blogs);
		for (Blog blog : blogs) {
			System.out.println(blog);
		}

	}
	@Test
	public void testGetAllBlogsByName() {
		List<Blog> blogs = blogService.getBlogsByName("test1@blog.com", "BLOG_ID");
		Assert.assertNotNull(blogs);
		for (Blog blog : blogs) {
			System.out.println(blog);
		}

	}
	
	@Test
	public void testInsertBlog() {
		Blog blog = new Blog();
		blog.setBlogName("test_blog_" + System.currentTimeMillis());
		blog.setCreatedOn(new Date());

		blogService.insertBlog(blog);
		
		Assert.assertTrue(blog.getBlogId() != 0);
		Blog createdBlog = blogService.getBlogById(blog.getBlogId());
		Assert.assertNotNull(createdBlog);
		Assert.assertEquals(blog.getBlogName(), createdBlog.getBlogName());

	}
	
	@Test
	public void testUpdateBlog() {
		long timestamp = System.currentTimeMillis();
		Blog blog = blogService.getBlogById(2);
		blog.setBlogName("TestBlogName" + timestamp);
		blogService.updateBlog(blog);
		Blog updatedBlog = blogService.getBlogById(2);
		Assert.assertEquals(blog.getBlogName(), updatedBlog.getBlogName());
	}
	
	@Test
	public void testDeleteBlog() {
		Blog blog = blogService.getBlogById(4);
		blogService.deleteBlog(blog.getBlogId());
		Blog deletedBlog = blogService.getBlogById(4);
		Assert.assertNull(deletedBlog);
	}
}
