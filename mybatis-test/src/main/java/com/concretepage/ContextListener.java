package com.concretepage;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.log4j.Logger;

import com.concretepage.blog.BlogService;

import java.io.IOException;
import java.nio.charset.Charset;
import java.sql.SQLException;

import javax.servlet.*;

public class ContextListener implements ServletContextListener {

	private Logger logger = Logger.getLogger(ContextListener.class);
	
	private ServletContext context = null;

	private void runScript(String scriptURI) {
		logger.info("--- runBlogScript ---");
				
		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		Charset charset = Resources.getCharset();
		try {
			// make sure that the SQL file has been saved in UTF-8!
			Resources.setCharset(Charset.forName("utf-8"));
			BaseDataTest.runScript(sqlSessionFactory.getConfiguration().getEnvironment().getDataSource(),
					scriptURI);
		} catch (IOException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		
		} finally {
			Resources.setCharset(charset);
		}
	}
	
	
	
	
	public void contextInitialized(ServletContextEvent event) {
		logger.info("--- contextInitialized ---");
		runScript("com/concretepage/blog/blog.sql");
		runScript("com/concretepage/user/User.sql");
		runScript("com/concretepage/village/Village.sql");
		
	}

	public void contextDestroyed(ServletContextEvent event) {
		logger.info("--- contextDestroyed ---");
		context = event.getServletContext();
		
	}
}