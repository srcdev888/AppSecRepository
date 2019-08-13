<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Blogs Application</title>
</head>
<body>
    <center>
        <h1>Blogs Management</h1>
        <h2>
            <a href="/blog/new">Add New Blog</a>
            &nbsp;&nbsp;&nbsp;
            <a href="/blog/list">List All Books</a>
        </h2>
    </center>
    <div align="center">
        <c:if test="${blog != null}">
            <form action="/blog/update" method="post">
        </c:if>
        <c:if test="${blog == null}">
            <form action="/blog/insert" method="post">
        </c:if>
        <table border="1" cellpadding="5">
            <caption>
                <h2>
                    <c:if test="${blog != null}">
                        Edit Blog
                    </c:if>
                    <c:if test="${blog == null}">
                        Add New Blog
                    </c:if>
                </h2>
            </caption>
                <c:if test="${blog != null}">
                    <input type="hidden" name="blogId" value="<c:out value='${blog.blogId}' />" />
                </c:if>           
            <tr>
                <th>Name: </th>
                <td>
                    <input type="text" name="blogName" size="45"
                            value="<c:out value='${blog.blogName}' />"
                        />
                </td>
            </tr>
            <tr>
                <th>Created On: </th>
                <td>
                <c:if test="${blog != null}">
                	<input type="text" name="createdOn" size="5"
                    	value="<fmt:formatDate type='both' dateStyle="long" 
                    	timeStyle="long" value='${blog.createdOn}' />"
                    />
                </c:if>
                <c:if test="${blog == null}">
                	<c:set var = "now" value = "<%=new java.util.Date()%>" />
                	<input type="text" name="createdOn" size="5"
                    	value="<fmt:formatDate type='both' dateStyle="long" 
                    	timeStyle="long" value='${now}' />"
                    />
                </c:if>
                    
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value="Save" />
                </td>
            </tr>
        </table>
        </form>
    </div>   
</body>
</html>