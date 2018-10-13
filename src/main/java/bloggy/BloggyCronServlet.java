package bloggy;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;



public class BloggyCronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(BloggyCronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {

		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
	
	try {
		 _logger.info("Cron Job has been executed");
		 
		  DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		  Query query = new Query("subscribeEmail");		  		 
		  List<Entity> subscribers = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		  
		  for(Entity sub : subscribers) {
			  Message msg = new MimeMessage(session);
			  msg.setFrom(new InternetAddress("admin@bloggy-219203.appspotmail.com", "Bloggy Admin"));
			  String emailAddress = (String) sub.getProperty("emailAddress");
			  msg.addRecipient(Message.RecipientType.TO,
		                   new InternetAddress(emailAddress));
			  msg.setSubject("The Most Exciting News Ever!");
			  msg.setText("Bloggy Daily Digest");
			  Transport.send(msg);
		  }
		} catch (AddressException e) {
		  // ...
		} catch (MessagingException e) {
		  // ...
		} catch (UnsupportedEncodingException e) {
		  // ...
		}
	
	
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException {
	doGet(req, resp);
	}
}
