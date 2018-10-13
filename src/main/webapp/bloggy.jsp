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
<%@ page import = "java.io.*,java.util.*" %>
<%@ page import = "javax.servlet.*,java.text.*" %>



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
	<%	String blogName = request.getParameter("blogName");
	if (blogName == null) {
    	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);
	
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user); %>
      
   	<a href="#" class="btn btn-dark btn-sm">Subscribe</a>	
	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="btn btn-dark btn-sm">
		Sign Out
	</a> 
	<a href="/post.jsp" class="btn btn-dark btn-sm">Create Post</a>
	<br><br>
<%	} else { %>

	<a href="<%= userService.createLoginURL(request.getRequestURI()) %>" class="btn btn-dark btn-sm">	
		Sign In
	</a> <br><br>

<% 	}

	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Key postKey = KeyFactory.createKey("Blog", blogName);

	Query query = new Query("Post", postKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> posts;
	Entity post;
	String all = request.getParameter("all");
	if (all != null && all.equals("true")) {
		posts = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
	}
	else {
		posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	}
	
	for (int i = 0; i < posts.size(); i++) {
		post = posts.get(i);
		pageContext.setAttribute("post_title", post.getProperty("title"));
		pageContext.setAttribute("post_content", post.getProperty("content"));
    	pageContext.setAttribute("post_user", post.getProperty("user"));
    	
    	Date date = (Date)post.getProperty("date");
      	SimpleDateFormat ft = new SimpleDateFormat ("MMM dd, YYYY");
      	pageContext.setAttribute("post_date", ft.format(date));
      	
      	%>
      	
      	

        <h3>${fn:escapeXml(post_title)}</h3>
        <p class="subtext">${fn:escapeXml(post_user.nickname)} | ${fn:escapeXml(post_date)}</p>
   		<blockquote>${fn:escapeXml(post_content)}</blockquote><hr>
<% 	}  

	if (all != null && all.equals("true")) { %>
		<a href="/bloggy.jsp?all=false" class="btn btn-dark btn-sm">See Less Posts</a>
<%	}
	
	else { %>
		<a href="/bloggy.jsp?all=true" class="btn btn-dark btn-sm">See All Posts</a>
<%	} %>

</body>

</html>