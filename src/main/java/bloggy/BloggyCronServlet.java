package bloggy;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Date;

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

import org.joda.time.DateTime;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
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
			  
			  String contentText = getContent(req);
			  if(!contentText.equals("")) msg.setText(contentText);
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
	
	public String getContent(HttpServletRequest req) {
		
		String blogName = req.getParameter("blogName");
		if (blogName == null) {
	    	blogName = "default";
		}
	
		Key postKey = KeyFactory.createKey("Blog", blogName);
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

		Query query = new Query("Post", postKey).addSort("date", Query.SortDirection.DESCENDING);
		List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
		String emailPost ="";

		for (Entity post : posts) {
	    	Date date = (Date) post.getProperty("date");
			boolean isBeforeYesterday = new DateTime( date).isBefore( DateTime.now().minusDays(1) );
			if(!isBeforeYesterday) {
				emailPost += post.getProperty("title") + "\n" + post.getProperty("content") + "\n\n";
	    	}

		}
		return emailPost;
//			pageContext.setAttribute("post_title", post.getProperty("title"));
//			pageContext.setAttribute("post_content", post.getProperty("content"));
//	    	pageContext.setAttribute("post_user", post.getProperty("user"));
//	    	
//	    	Date date = (Date)post.getProperty("date");
//	      	SimpleDateFormat ft = new SimpleDateFormat ("MMM dd, YYYY");
//	      	pageContext.setAttribute("post_date", ft.format(date));
//	      	
//	      	%>
//	      	
//	        <h3>${fn:escapeXml(post_title)}</h3>
//	        <p class="subtext">${fn:escapeXml(post_user.nickname)} | ${fn:escapeXml(post_date)}</p>
//	   		<pre>${fn:escapeXml(post_content)}</pre><hr>
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException {
	doGet(req, resp);
	}
}
