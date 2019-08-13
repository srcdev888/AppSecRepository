<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Blogs Application</title>
</head>
<body>
<center>
        <h1>Blogs Management</h1>
        <h2>
            <a href="/blog/new">Insert New Blog</a>
            &nbsp;&nbsp;&nbsp;
            <a href="/blog/list">List All Books</a>
        </h2>
    </center>
    
    <%-- Using JSTL forEach and out to loop a list and display items in table --%>
    <div align="center">
        <table border="1" cellpadding="5">
            <caption><b>List of Blogs</b></caption>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
            <c:if test="${not empty blogs}">
            <c:forEach var="blog" items="${blogs}">
                <tr>
                    <td><c:out value="${blog.blogId}" /></td>
                    <td><c:out value="${blog.blogName}" /></td>
                    <td><fmt:formatDate type='both' dateStyle="long" timeStyle="long" value='${blog.createdOn}' /></td>
                    <td>
                        <a href="/blog/edit?blogId=<c:out value='${blog.blogId}' />">Edit</a>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <a href="/blog/delete?blogId=<c:out value='${blog.blogId}' />">Delete</a>                     
                    </td>
                </tr>
            </c:forEach>
            </c:if>
        </table>
    </div>   
</body>
</html>