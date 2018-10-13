package bloggy;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
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



public class BloggyCronServlet extends HttpServlet {
	private static final Logger _logger = Logger.getLogger(BloggyCronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException {

		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
	
	try {
		 _logger.info("Cron Job has been executed");
		 
		  Message msg = new MimeMessage(session);
		  msg.setFrom(new InternetAddress("bloggy.admin@example.com", "Bloggy Admin"));
		  msg.addRecipient(Message.RecipientType.TO,
		                   new InternetAddress("user@example.com", "Mr. User"));
		  msg.setSubject("Your Example.com account has been activated");
		  msg.setText("This is a test");
		  Transport.send(msg);
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
