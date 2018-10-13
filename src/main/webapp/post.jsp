 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
 <html>
 <head></head>
 
 <body>
 <%
	String blogName = request.getParameter("blogName");
	if (blogName == null) {
 	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);
 %>
 	<form action="/post" method="post">
   <div><textarea name="content" rows="3" cols="60"></textarea></div>
   <input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
   <div><input type="submit" value="Post" ></div>
 </form>
 </body>
 
 </html>
