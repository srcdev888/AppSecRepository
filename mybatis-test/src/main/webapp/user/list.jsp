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
        <h1>User Management</h1>
        <h2>
            <a href="/user/new">Insert New User</a>
            &nbsp;&nbsp;&nbsp;
            <a href="/user/list">List All Users</a>
        </h2>
    </center>
    
    <%-- Using JSTL forEach and out to loop a list and display items in table --%>
    <div align="center">
        <table border="1" cellpadding="5">
            <caption><b>List of Users</b></caption>
            <tr>
                <th>UserId</th>
                <th>EmailId</th>
                <th>FirstName</th>
                <th>LastName</th>
                <th>Actions</th>
            </tr>
            <c:if test="${not empty users}">
            <c:forEach var="user" items="${users}">
                <tr>
                    <td><c:out value="${user.userId}" /></td>
                    <td><c:out value="${user.emailId}" /></td>
                    <td><c:out value="${user.firstName}" /></td>
                    <td><c:out value="${user.lastName}" /></td>
                    <td>
                        <a href="/user/edit?userId=<c:out value='${user.userId}' />">Edit</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="/user/delete?userId=<c:out value='${user.userId}' />">Delete</a>                     
                    </td>
                </tr>
            </c:forEach>
            </c:if>
        </table>
    </div>
    <div>
    	<form action="/user/search" method="post">
    	<table border="1" cellpadding="5">
    	<caption>
                <h2>
                Search By First Name
                </h2>
            </caption>
             <tr>
                <th>Name: </th>
                <td>
                    <input type="text" name="firstName" size="45" />
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