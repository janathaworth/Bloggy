package bloggy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Date;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class BloggyPostServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();

	    String blogName = req.getParameter("blogName");
        Key postKey = KeyFactory.createKey("Blog", blogName);
        String title = req.getParameter("title"); 
        String content = req.getParameter("content"); 
        Date date = new Date();
        Entity post = new Entity("Post", postKey);

        post.setProperty("user", user);
        post.setProperty("date", date);
        post.setProperty("title", title);
        post.setProperty("content", content);

        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(post);

        resp.sendRedirect("/bloggy.jsp?blogName=" + blogName);
	}
}