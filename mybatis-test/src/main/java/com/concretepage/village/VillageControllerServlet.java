package com.concretepage.village;

import java.io.IOException;
import java.text.ParseException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.log4j.Logger;

import com.concretepage.SqlSessionFactoryManager;
import com.concretepage.user.User;
import com.concretepage.user.UserService;

public class VillageControllerServlet  extends HttpServlet {
	
	private static Logger logger = Logger.getLogger(VillageControllerServlet.class);
	
	private VillageDAO villageService;
	
	public void init() {
		SqlSessionFactory sqlSessionFactory = SqlSessionFactoryManager.getSqlSessionFactory();
		villageService = new VillageDAO();
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
            	            
	            case "/village/delete":
	                deleteVillage(request, response);
	                break;
            
	            case "/village/new":
	                showNewForm(request, response);
	                break;
	            	            
	            case "/village/insert":
	                insertVillage(request, response);
	                break;
	            
	            case "/village/edit":
	                showEditForm(request, response);
	                break;
	                
	            case "/village/update":
	                updateVillage(request, response);
	                break;
	                
	            case "/village/search":
	            	searchByName(request, response);
	            	break;
	            
	            case "/village/search2":
		            searchByCountryAndDistrict(request, response);
		            break;
	            	
	            default:
	                listVillages(request, response);
	                break;
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
	}
	
	private void listVillages(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<Village> villages = villageService.getAll();
        logger.debug("len of villages: "+villages.size());
        
        for(Village village: villages) {
        	logger.debug(village);
        }
        
        request.setAttribute("villages", villages);
        request.getRequestDispatcher("/village/list.jsp").forward(request,  response);
        
        //RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/list.jsp");
        //dispatcher.forward(request, response);
    }
	

	private void deleteVillage(HttpServletRequest request, HttpServletResponse response)
			 throws IOException, ServletException {
	        int id = Integer.parseInt(request.getParameter("id"));
	        
	        villageService.delete(id);
	        response.sendRedirect("/village/list");
	 }
	
	private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("/village/form.jsp");
        dispatcher.forward(request, response);
    }
	
	private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        Village village = villageService.getVillage(id);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/village/form.jsp");
        request.setAttribute("village", village);
        dispatcher.forward(request, response);
 
    }
	
	private void searchByName(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		String name = request.getParameter("name");
        
		List<Village> villages = villageService.getVillageByName(name);
		
		request.setAttribute("villages", villages);
        request.getRequestDispatcher("/village/list.jsp").forward(request,  response);
		
        /*
        RequestDispatcher dispatcher = request.getRequestDispatcher("/village/form.jsp");
        request.setAttribute("village", village);
        dispatcher.forward(request, response);
        */
	}
	
	private void searchByCountryAndDistrict(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		
		String country = request.getParameter("country");
		String district = request.getParameter("district");
        
		LocationDataEntity locationDataEntity = new LocationDataEntity();
		locationDataEntity.setCountry(country);
		locationDataEntity.setDistrict(district);
		
        List<Village> villages = villageService.getVillageByCountryAndDistrict(locationDataEntity);
        
        request.setAttribute("villages", villages);
        request.getRequestDispatcher("/village/list.jsp").forward(request,  response);
        
        /*
        RequestDispatcher dispatcher = request.getRequestDispatcher("/village/form.jsp");
        request.setAttribute("village", village);
        dispatcher.forward(request, response);
        */
	}
	
 	
	private void insertVillage(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        
        String name = request.getParameter("name");
        String district = request.getParameter("district");
        String country = request.getParameter("country");
        
        Village village = new Village();
        village.setName(name);
        village.setDistrict(district);
        village.setCountry(country);
        
        villageService.save(village);
        response.sendRedirect("/village/list");
    }
	
	private void updateVillage(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ParseException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String district = request.getParameter("district");
        String country = request.getParameter("country");
        
        Village village = new Village();
        village.setId(id);
        village.setName(name);
        village.setDistrict(district);
        village.setCountry(country);
        
        villageService.update(village);
        response.sendRedirect("/village/list");
    }
	
}
