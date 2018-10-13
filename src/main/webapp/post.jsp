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
	
 	<form action="/post" method="post" class="form-horizontal">
 		<!-- <div><textarea name="title" rows="1" cols="60"></textarea></div> -->
 		
 		<div class="form-group">
      		<label class="col-sm-2 control-label">Title</label>
     		 <div class="col-sm-8">
        		<input class="form-control" id="focusedInput" type="text" name="title">
      		</div>
    	</div>
    	
 		<!-- <input class="form-control" id="focusedInput" name="title"> -->
 		
 		<div class="form-group">
      		<label class="col-sm-2 control-label">Content</label>
     		 <div class="col-sm-8">
        		<textarea class="form-control" id="focusedInput" rows="5" name="content"></textarea>
      		</div>
    	</div>
 		
   		<!-- div><textarea name="content" rows="3" cols="60"></textarea></div> -->
   		<input type="hidden" name="blogName" value="${fn:escapeXml(blogName)}">
   		<div>
   			<input type="submit" value="Post" class="btn btn-dark btn-sm">
   			<a href="/bloggy.jsp" class="btn btn-dark btn-sm">Cancel</a>
   		</div>
   		
 	</form>
 </body>
 
 </html>
