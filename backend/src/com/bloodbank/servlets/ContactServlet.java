package com.bloodbank.servlets;

import com.bloodbank.util.EmailService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ContactServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        if (name != null && email != null && message != null && !name.trim().isEmpty() && !email.trim().isEmpty() && !message.trim().isEmpty()) {
            EmailService.notifyAdminOfContactMessage(name, email, message);
            request.getSession().setAttribute("contactSuccess", "Your message has been sent successfully! Our team will contact you soon.");
        } else {
            request.getSession().setAttribute("contactError", "Please fill in all fields correctly.");
        }
        
        response.sendRedirect("contact.jsp");
    }
}
