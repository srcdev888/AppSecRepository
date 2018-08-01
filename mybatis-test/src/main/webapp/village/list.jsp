<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>User Application</title>
</head>
<body>
<center>
        <h1>Village Management</h1>
        <h2>
            <a href="/village/new">Insert New Village</a>
            &nbsp;&nbsp;&nbsp;
            <a href="/village/list">List All Villages</a>
        </h2>
    </center>
    
    <%-- Using JSTL forEach and out to loop a list and display items in table --%>
    <div align="center">
        <table border="1" cellpadding="5">
            <caption><b>List of Users</b></caption>
            <tr>
                <th>Id</th>
                <th>Name</th>
                <th>District</th>
                <th>Country</th>
                <th>Actions</th>
            </tr>
            <c:if test="${not empty villages}">
            <c:forEach var="village" items="${villages}">
                <tr>
                    <td><c:out value="${village.id}" /></td>
                    <td><c:out value="${village.name}" /></td>
                    <td><c:out value="${village.district}" /></td>
                    <td><c:out value="${village.country}" /></td>
                    <td>
                        <a href="/village/edit?id=<c:out value='${village.id}' />">Edit</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="/village/delete?id=<c:out value='${village.id}' />">Delete</a>                     
                    </td>
                </tr>
            </c:forEach>
            </c:if>
        </table>
    </div>
    <div>
    	<form action="/village/search" method="post">
    	<table border="1" cellpadding="5">
    	<caption>
                <h2>
                Search By Name
                </h2>
            </caption>
             <tr>
                <th>Name: </th>
                <td>
                    <input type="text" name="name" size="45" />
                </td>
            </tr>
    		<tr>
                <td colspan="2" align="center">
                    <input type="submit" value="Search" />
                </td>
            </tr>
        </table>
    	</form>
    </div>
        <div>
    	<form action="/village/search2" method="post">
    	<table border="1" cellpadding="5">
    	<caption>
                <h2>
                Search By Country And District
                </h2>
            </caption>
             <tr>
                <th>Country: </th>
                <td>
                    <input type="text" name="country" size="45" />
                </td>
            </tr>
            <tr>
                <th>District: </th>
                <td>
                    <input type="text" name="district" size="45" />
                </td>
            </tr>
    		<tr>
                <td colspan="2" align="center">
                    <input type="submit" value="Search" />
                </td>
            </tr>
        </table>
    	</form>
    </div>
</body>
</html>