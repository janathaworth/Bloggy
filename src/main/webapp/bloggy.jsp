<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="java.util.List" %>



<html>
<head></head>
<body>

	<div style="display:flex">
		<h1>Bloggy</h1>
		<img src="/maxresdefault.jpg" style="width:80px; height: 60px;">
	</div>
		
	<button type="button">Subscribe</button>	
<%	
	String blogName = request.getParameter("blogName");
	if (blogName == null) {
    	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);
	
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
		<button type="button">Sign Out</button>
	</a> 
	<hr>
	<a href="/post.jsp"><button type="button">Create Post</button></a>
<%
    } else {
%>
	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">	
		<button type="button">Sign In</button>
	</a> 
	<hr>
<% 
    }

DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
Key postKey = KeyFactory.createKey("Blog", blogName);

Query query = new Query("Post", postKey).addSort("date", Query.SortDirection.DESCENDING);
List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));

for (Entity post : posts) {
	pageContext.setAttribute("post_content", post.getProperty("content"));

	if (post.getProperty("user") == null) {
    %>
    	<p>An anonymous person wrote:</p>
   	<%
    } else {

    	pageContext.setAttribute("post_user", post.getProperty("user"));
        %>
        <p><b>${fn:escapeXml(post_user.nickname)}</b> wrote:</p>
     	<%
    }
    %>
    <blockquote>${fn:escapeXml(post_content)}</blockquote>
	<%
}
%>
</body>

</html>