package bloggy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class BloggyEmailServlet extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

	    String blogName = req.getParameter("blogName");
	    String emailAddress = user.getEmail();
		    
	    String unsubscriber = req.getParameter("delete");
	    
	    if(unsubscriber.equals("true")) {
	    	Key postKey = KeyFactory.createKey("subscribeEmail", emailAddress);
	    	datastore.delete(postKey);
	    }
	    else {
		    Entity subscriber = new Entity("subscribeEmail", emailAddress);
		    subscriber.setProperty("emailAddress", user.getEmail());
		    datastore.put(subscriber);
	    }
        resp.sendRedirect("/bloggy.jsp?blogName=" + blogName);
	}
}
