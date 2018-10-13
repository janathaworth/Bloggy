<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.EntityNotFoundException" %>

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
		<h1>Blogg</h1>
		<img src="/maxresdefault.jpg" style="width:80px; height: 60px;">
	</div>
	<%	String blogName = request.getParameter("blogName");
	if (blogName == null) {
    	blogName = "default";
	}
	pageContext.setAttribute("blogName", blogName);
	
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    
    if (user != null) {
      pageContext.setAttribute("user", user); 
      Key postKey = KeyFactory.createKey("subscribeEmail", user.getEmail());
	  
	  try {
		  Entity subscriber = datastore.get(postKey); %>
		  <form action="/email" method="post">
    		<input type="submit" value="Unsubscribe" class="btn btn-dark btn-sm">
    		<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}">
    		<input type="hidden" name="delete" value="true">
    		
    	  </form>
	<%}
	  catch(EntityNotFoundException e) { %>
	      
	      <form action="/email" method="post">
	   		<input type="submit" value="Subscribe" class="btn btn-dark btn-sm">
	   		<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}">
	   		<input type="hidden" name="delete" value="false">
	   		
	   	  </form>
	   	  
     	
	<%}%>
   	
   	
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

	
	Key postKey = KeyFactory.createKey("Blog", blogName);

	Query query = new Query("Post", postKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> posts;
	String all = request.getParameter("all");
	if (all != null && all.equals("true")) {
		posts = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
	}
	else {
		posts = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	}
	
	for (Entity post : posts) {
		pageContext.setAttribute("post_title", post.getProperty("title"));
		pageContext.setAttribute("post_content", post.getProperty("content"));
    	pageContext.setAttribute("post_user", post.getProperty("user"));
    	
    	Date date = (Date)post.getProperty("date");
      	SimpleDateFormat ft = new SimpleDateFormat ("MMM dd, YYYY");
      	pageContext.setAttribute("post_date", ft.format(date));
      	
      	%>
      	
        <h3>${fn:escapeXml(post_title)}</h3>
        <p class="subtext">${fn:escapeXml(post_user.nickname)} | ${fn:escapeXml(post_date)}</p>
   		<pre>${fn:escapeXml(post_content)}</pre><hr>
<% 	}  

	if (all != null && all.equals("true")) { %>
		<a href="/bloggy.jsp?all=false" class="btn btn-dark btn-sm">See Less Posts</a>
<%	}
	
	else { %>
		<a href="/bloggy.jsp?all=true" class="btn btn-dark btn-sm">See All Posts</a>
<%	} %>

</body>

</html>