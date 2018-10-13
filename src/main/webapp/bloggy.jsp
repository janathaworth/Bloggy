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
	String title = request.getParameter("title");
	if (title == null) {
    	title = "default";
	}
	pageContext.setAttribute("title", title);
	
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">
	<button type="button">Sign In</button>
</a>
<%
    } else {
%>
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">	
	<button type="button">Sign In</button>
</a>
	<hr>
<!-- 	<button type="button">Create Post</button>
 -->	

 <form action="/post" method="post">
   <div><textarea name="content" rows="3" cols="60"></textarea></div>
   <div><input type="submit" value="Post" ></div>
   <input type="hidden" name="title" value="${fn:escapeXml(title)}"/>
 </form>	
<% 
    }
    
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key postKey = KeyFactory.createKey("Blog", title);

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
            <p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
         	<%
        }
        %>
        <blockquote>${fn:escapeXml(post_content)}</blockquote>
		<%
	}
%>	
	
	
</body>

</html>