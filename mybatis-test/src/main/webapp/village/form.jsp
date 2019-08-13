<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Village Application</title>
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
    <div align="center">
        <c:if test="${village != null}">
            <form action="/village/update" method="post">
        </c:if>
        <c:if test="${village == null}">
            <form action="/village/insert" method="post">
        </c:if>
        <table border="1" cellpadding="5">
            <caption>
                <h2>
                    <c:if test="${village != null}">
                        Edit Village
                    </c:if>
                    <c:if test="${village == null}">
                        Add New Village
                    </c:if>
                </h2>
            </caption>
                <c:if test="${village != null}">
                    <input type="hidden" name="id" value="<c:out value='${village.id}' />" />
                </c:if>           
            <tr>
                <th>Name: </th>
                <td>
                    <input type="text" name="name" size="45"
                            value="<c:out value='${village.name}' />"
                        />
                </td>
            </tr>
            <tr>
                <th>District: </th>
                <td>
                    <input type="text" name="district" size="45"
                            value="<c:out value='${village.district}' />"
                        />
                </td>
            </tr>
            <tr>
                <th>Country: </th>
                <td>
                    <input type="text" name="country" size="45"
                            value="<c:out value='${village.country}' />"
                        />
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