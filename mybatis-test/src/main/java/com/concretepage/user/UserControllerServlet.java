package com.concretepage.user;

import java.io.IOException;
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
import com.concretepage.blog.Blog;
import com.concretepage.blog.BlogService;
import com.concretepage.village.Village;

public class UserControllerServlet extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(UserControllerServlet.class);
	
	private UserService userService;
	
	public void init() {
		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		userService = new UserService();
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
            
	            case "/user/delete":
	                deleteUser(request, response);
	                break;
            
	            case "/user/new":
	                showNewForm(request, response);
	                break;
	            	            
	            case "/user/insert":
	                insertUser(request, response);
	                break;
	            
	            case "/user/edit":
	                showEditForm(request, response);
	                break;
	                
	            case "/user/update":
	                updateUser(request, response);
	                break;
	            
	            case "/user/search":
	            	searchByName(request, response);
	            	break;
	                
	            default:
	                listUsers(request, response);
	                break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
	}
	
	private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<User> users = userService.getAllUsers();
        logger.debug("len of users: "+users.size());
        
        for(User user: users) {
        	logger.debug(user);
        }
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/user/list.jsp").forward(request,  response);
        
        //RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/list.jsp");
        //dispatcher.forward(request, response);
    }
	
	private void deleteUser(HttpServletRequest request, HttpServletResponse response)
			 throws IOException, ServletException {
	        int id = Integer.parseInt(request.getParameter("userId"));
	        
	        userService.deleteUser(id);
	        response.sendRedirect("/user/list");
	 }
	
	private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/form.jsp");
        dispatcher.forward(request, response);
    }
	
	private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("userId"));
        
        User user = userService.getUserById(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/user/form.jsp");
        request.setAttribute("user", user);
        dispatcher.forward(request, response);
 
    }
 	
	private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        
        String emailId = request.getParameter("emailId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String password = request.getParameter("password");
        
        
        User user = new User();
        user.setEmailId(emailId);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPassword(password);
        
        userService.insertUser(user);
        response.sendRedirect("/user/list");
    }
	
	private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        int id = Integer.parseInt(request.getParameter("userId"));
        String emailId = request.getParameter("emailId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String password = request.getParameter("password");
        
        User user = new User();
        user.setUserId(id);
        user.setEmailId(emailId);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPassword(password);
        
        userService.updateUser(user);
        response.sendRedirect("/user/list");
    }
	
	private void searchByName(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		String firstName = request.getParameter("firstName");
        
		List<User> users = userService.getUserByFirstName(firstName);
		
		request.setAttribute("users", users);
        request.getRequestDispatcher("/user/list.jsp").forward(request,  response);
		
        /*
        RequestDispatcher dispatcher = request.getRequestDispatcher("/village/form.jsp");
        request.setAttribute("village", village);
        dispatcher.forward(request, response);
        */
	}
}
