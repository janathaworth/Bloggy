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
<head>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
	<link rel="stylesheet" href="main.css">
</head>
<body>

	<div style="display:flex; padding-bottom:1em;">
		<h1>Bloggy</h1>
		<img src="/maxresdefault.jpg" style="width:80px; height: 60px;">
	</div>
	<a href="#" class="btn btn-dark btn-sm">Subscribe</a>	
	<%	String blogName = request.getParameter("blogName");
	if (blogName == null) {
    	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);
	
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user); %>
   
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="btn btn-dark btn-sm">
		Sign Out
	</a> 
	<hr>
	<a href="/post.jsp" class="btn btn-dark btn-sm">Create Post</a>
	<br><br>
<%	} else { %>

	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="btn btn-dark btn-small">	
		Sign In
	</a> 
	<hr>

<% 	}

	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key postKey = KeyFactory.createKey("Blog", blogName);

	Query query = new Query("Post", postKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));

	for (Entity post : posts) {
		pageContext.setAttribute("post_title", post.getProperty("title"));
		pageContext.setAttribute("post_content", post.getProperty("content"));
    	pageContext.setAttribute("post_user", post.getProperty("user"));
    	pageContext.setAttribute("post_date", post.getProperty("date")); %>

        <h3>${fn:escapeXml(post_title)}</h3>
        <p class="subtext">${fn:escapeXml(post_user.nickname)}, ${fn:escapeXml(post_date)}</p>
   		<blockquote>${fn:escapeXml(post_content)}</blockquote>
   		<br>
<% 	}   %>

</body>

</html>