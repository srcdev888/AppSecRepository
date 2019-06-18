package com.concretepage.blog;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.log4j.Logger;

import com.concretepage.SqlSessionFactoryManager;
import com.concretepage.Utility;

public class BlogControllerServlet extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(BlogControllerServlet.class);
	
	private static final long serialVersionUID = 1L;
	
	private BlogService blogService;
	
	public void init() {
		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		blogService = new BlogService();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		String action = request.getServletPath();
		logger.debug("action: "+action);
		
        try {
            switch (action) {
            
	            case "/blog/delete":
	                deleteBlog(request, response);
	                break;
            
	            case "/blog/new":
	                showNewForm(request, response);
	                break;
	            	            
	            case "/blog/insert":
	                insertBlog(request, response);
	                break;
	            
	            case "/blog/edit":
	                showEditForm(request, response);
	                break;
	                
	            case "/blog/update":
	                updateBlog(request, response);
	                break;
	                
	            default:
	                listBlog(request, response);
	                break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
	}
	
	private void listBlog(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<Blog> blogs = blogService.getAllBlogs();
        logger.debug("len of blogs: "+blogs.size());
        
        for(Blog blog: blogs) {
        	logger.debug(blog);
        }
        
        request.setAttribute("blogs", blogs);
        request.getRequestDispatcher("/blog/list.jsp").forward(request,  response);
        
        //RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/list.jsp");
        //dispatcher.forward(request, response);
    }
	
	 private void deleteBlog(HttpServletRequest request, HttpServletResponse response)
			 throws IOException, ServletException {
	        int id = Integer.parseInt(request.getParameter("blogId"));
	        
	        blogService.deleteBlog(id);
	        response.sendRedirect("/blog/list");
	 }
 
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/blog/form.jsp");
        dispatcher.forward(request, response);
    }
    
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("blogId"));
        logger.debug("id: "+id);
        Blog blog = blogService.getBlogById(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/blog/form.jsp");
        request.setAttribute("blog", blog);
        dispatcher.forward(request, response);
 
    }
 
    private void insertBlog(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        String blogName = request.getParameter("blogName");
        String createdOn = request.getParameter("createdOn");
        logger.debug("createdOn: "+createdOn);
        
        String pattern = "MMM dd,yyyy HH:mm:ss a z";
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        java.util.Date uDate = format.parse(createdOn);
        
        Blog blog = new Blog();
        blog.setBlogName(blogName);
        blog.setCreatedOn(Utility.convertUtilToSql(uDate));
        
        blogService.insertBlog(blog);
        response.sendRedirect("/blog/list");
    }
 
    private void updateBlog(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        int id = Integer.parseInt(request.getParameter("blogId"));
        String blogName = request.getParameter("blogName");
        String createdOn = request.getParameter("createdOn");
        
        String pattern = "MMM dd,yyyy HH:mm:ss a z";
        SimpleDateFormat format = new SimpleDateFormat(pattern);
        java.util.Date uDate = format.parse(createdOn);
        
        Blog blog = new Blog();
        blog.setBlogId(id);
        blog.setBlogName(blogName);
        blog.setCreatedOn(Utility.convertUtilToSql(uDate));
        
        blogService.updateBlog(blog);
        response.sendRedirect("/blog/list");
    }
 
   
 
   
	
}
