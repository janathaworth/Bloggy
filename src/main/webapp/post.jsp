 <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
 
 <html>
 <head>
 	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
 </head>
 
 <body>
 <% String blogName = request.getParameter("blogName");
	if (blogName == null) {
 	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);  %>
	
 	<form action="/post" method="post">
 		<div><textarea name="title" rows="1" cols="60"></textarea></div>
   		<div><textarea name="content" rows="3" cols="60"></textarea></div>
   		<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}"/>
   		<div>
   			<input type="submit" value="Post" class="btn btn-dark btn-sm">
   			<a href="/bloggy.jsp" class="btn btn-dark btn-sm">Cancel</a>
   		</div>
   		
 	</form>
 </body>
 
 </html>
