package com.bloodbank.util;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    // ⚠️ IMPORTANT: You must replace these with your actual Gmail and App Password!
    // For Gmail, you must enable 2-Step Verification and generate an "App Password"
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static String USERNAME; 
    private static String PASSWORD;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        try (java.io.InputStream input = EmailService.class.getClassLoader().getResourceAsStream("config.properties")) {
            java.util.Properties prop = new java.util.Properties();
            if (input == null) {
                // Fallback to direct file path if not in classpath resources (for dev environment)
                try (java.io.FileInputStream fis = new java.io.FileInputStream("c:\\Users\\vijay\\OneDrive\\Desktop\\lifeflow-OG-main\\backend\\src\\config.properties")) {
                    prop.load(fis);
                }
            } else {
                prop.load(input);
            }
            USERNAME = prop.getProperty("gmail.username");
            PASSWORD = prop.getProperty("gmail.password");
            System.out.println("📧 Email configurations loaded successfully.");
        } catch (Exception ex) {
            System.err.println("❌ Unable to find config.properties or load configurations.");
            ex.printStackTrace();
        }
    }

    public static void sendOtpEmail(String toAddress, String otp) {
        sendEmail(toAddress, 
            "LifeFlow - Your Password Reset OTP", 
            "LifeFlow Password Reset", 
            "You recently requested to reset your password. Use the following OTP to complete the process:", 
            otp);
    }

    public static void sendRegistrationOtpEmail(String toAddress, String otp) {
        sendEmail(toAddress, 
            "LifeFlow - Complete Your Registration", 
            "Welcome to LifeFlow!", 
            "Thank you for joining our life-saving community. Use the following OTP to verify your email address and complete your registration:", 
            otp);
    }

    public static void sendAccountApprovalEmail(String toAddress, String fullName) {
        System.out.println("Attempting to send account approval email to: " + toAddress);
        
        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #10b981; border-radius: 8px;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h1 style='color: #10b981; margin: 0;'>Account Approved!</h1>"
                + "  <p style='color: #666; font-size: 1.2em; margin-top: 5px;'>Welcome to the LifeFlow Network.</p>"
                + "</div>"
                + "<p style='font-size: 1.1em;'>Hi " + fullName + ",</p>"
                + "<p style='font-size: 1.1em; line-height: 1.6;'>We are pleased to inform you that your registration has been <strong>approved</strong> by the LifeFlow administration.</p>"
                + "<div style='background: #f0fdf4; border-left: 4px solid #10b981; padding: 15px; margin: 25px 0;'>"
                + "  <p style='margin: 0; font-size: 1.0em; color: #064e3b;'>You can now log in to your dashboard to access all features, manage your profile, and start helping save lives.</p>"
                + "</div>"
                + "<div style='text-align: center; margin-top: 30px;'>"
                + "  <a href='http://localhost:9090/blood-bank/login.jsp' style='background-color: #e11d48; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 1.1em;'>Log In Now</a>"
                + "</div>"
                + "<p style='font-size: 0.8em; color: #999; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; text-align: center;'>If you have any questions, feel free to contact our support team.</p>"
                + "</div>";

        sendRawEmail(toAddress, "LifeFlow - Registration Approved!", htmlBody);
    }

    private static void sendEmail(String toAddress, String subject, String title, String description, String otp) {
        System.out.println("Attempting to send OTP email to: " + toAddress);
        System.out.println("=====================================================");
        System.out.println("🔑 [LOCAL FALLBACK] GENERATED OTP FOR " + toAddress + ": " + otp);
        System.out.println("=====================================================");

        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 20px; color: #333;'>"
                + "<h2 style='color: #e11d48;'>" + title + "</h2>"
                + "<p>" + description + "</p>"
                + "<h1 style='background: #f1f5f9; padding: 15px; border-radius: 8px; letter-spacing: 5px; text-align: center; color: #0f172a;'>" + otp + "</h1>"
                + "<p style='font-size: 0.9em; color: #666;'>If you did not make this request, please ignore this email.</p>"
                + "</div>";
                
        sendRawEmail(toAddress, subject, htmlBody);
    }

    private static void sendRawEmail(String toAddress, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            message.setSubject(subject);
            message.setContent(htmlBody, "text/html");
            Transport.send(message);
            System.out.println("✅ Email sent successfully to " + toAddress);
        } catch (MessagingException e) {
            System.err.println("❌ Failed to send email to " + toAddress);
            e.printStackTrace();
        }
    }

    public static void sendEmergencyBroadcastEmail(java.util.List<String> bccEmails, String bloodGroup, String facilityName, String emergencyMessage) {
        if (bccEmails == null || bccEmails.isEmpty()) return;
        
        System.out.println("Attempting to send EMERGENCY email broadcast to " + bccEmails.size() + " donors.");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "LifeFlow Emergency Center"));
            
            // Set all donors as BCC to protect their privacy
            InternetAddress[] bccAddresses = new InternetAddress[bccEmails.size()];
            for (int i = 0; i < bccEmails.size(); i++) {
                bccAddresses[i] = new InternetAddress(bccEmails.get(i));
            }
            message.setRecipients(Message.RecipientType.BCC, bccAddresses);
            
            // So the 'To' field isn't completely blank, set it to the system email
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(USERNAME));
            
            message.setSubject("🚨 URGENT: " + bloodGroup + " Blood Needed Immediately at " + facilityName);
            
            String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #e11d48; border-radius: 8px;'>"
                    + "<div style='text-align: center; margin-bottom: 20px;'>"
                    + "  <h1 style='color: #e11d48; margin: 0;'>CRITICAL DEMAND</h1>"
                    + "  <p style='color: #666; font-size: 1.2em; margin-top: 5px;'>Your community needs you.</p>"
                    + "</div>"
                    + "<p style='font-size: 1.1em;'>Dear Donor,</p>"
                    + "<p style='font-size: 1.1em; line-height: 1.6;'>A medical emergency has resulted in a critical shortage of <strong>" + bloodGroup + "</strong> blood. Because you are uniquely positioned to help, we are contacting you immediately.</p>"
                    + "<div style='background: #fee2e2; border-left: 4px solid #ef4444; padding: 15px; margin: 25px 0;'>"
                    + "  <p style='margin: 0; font-size: 1.1em; color: #7f1d1d;'><strong>Facility:</strong> " + facilityName + "</p>"
                    + "  <p style='margin: 10px 0 0 0; font-size: 1.0em; color: #991b1b;'><em>\"" + (emergencyMessage != null ? emergencyMessage : "Urgent stock required to handle trauma/surgical event.") + "\"</em></p>"
                    + "</div>"
                    + "<p style='font-size: 1.1em; line-height: 1.6;'>If you are healthy and able to donate, please proceed to the facility or open your LifeFlow App to book a fast-track appointment.</p>"
                    + "<div style='text-align: center; margin-top: 30px;'>"
                    + "  <a href='http://localhost:9090/blood-bank/login.jsp' style='background-color: #e11d48; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 1.1em;'>Respond to Request</a>"
                    + "</div>"
                    + "<p style='font-size: 0.8em; color: #999; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; text-align: center;'>This is an automated emergency broadcast generated by the LifeFlow Medical Grid.</p>"
                    + "</div>";
                    
            message.setContent(htmlBody, "text/html");
            Transport.send(message);
            System.out.println("✅ EMERGENCY Email broadcast successfully sent to " + bccEmails.size() + " donors.");
        } catch (Exception e) {
            System.err.println("❌ Failed to broadcast emergency email.");
            e.printStackTrace();
        }
    }

    public static void sendPeerEmergencyEmail(java.util.List<String> bccEmails, String bloodGroup, String city, String hospitalName, String urgency) {
        if (bccEmails == null || bccEmails.isEmpty()) return;
        
        System.out.println("Attempting to send PEER EMERGENCY email to " + bccEmails.size() + " donors in " + city);

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(USERNAME, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(USERNAME, "LifeFlow Community Alert"));
            
            InternetAddress[] bccAddresses = new InternetAddress[bccEmails.size()];
            for (int i = 0; i < bccEmails.size(); i++) {
                bccAddresses[i] = new InternetAddress(bccEmails.get(i));
            }
            message.setRecipients(Message.RecipientType.BCC, bccAddresses);
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(USERNAME));
            
            message.setSubject("🚨 PEER ALERT: Urgent " + bloodGroup + " Needed in " + city);
            
            String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #e11d48; border-radius: 8px;'>"
                    + "<div style='text-align: center; margin-bottom: 20px;'>"
                    + "  <h1 style='color: #e11d48; margin: 0;'>COMMUNITY EMERGENCY</h1>"
                    + "  <p style='color: #666; font-size: 1.1em; margin-top: 5px;'>A patient nearby needs your help.</p>"
                    + "</div>"
                    + "<p style='font-size: 1.0em;'>Someone in your community has broadcast an urgent need for <strong>" + bloodGroup + "</strong> blood.</p>"
                    + "<div style='background: #fff5f5; border: 1px solid #fed7d7; padding: 20px; border-radius: 6px; margin: 25px 0;'>"
                    + "  <p style='margin: 0; font-size: 1.1em; color: #c53030;'><strong>Hospital:</strong> " + hospitalName + "</p>"
                    + "  <p style='margin: 5px 0 0 0; font-size: 1.0em; color: #742a2a;'><strong>City:</strong> " + city + "</p>"
                    + "  <p style='margin: 10px 0 0 0; font-size: 0.9em; background: #feb2b2; display: inline-block; padding: 2px 8px; border-radius: 4px; color: #9b2c2c; font-weight: bold;'>" + urgency.toUpperCase() + "</p>"
                    + "</div>"
                    + "<p style='line-height: 1.6;'>Because you match this blood group and are in the same city, you are being notified immediately. If you can help, please reach out or proceed to the hospital.</p>"
                    + "<div style='text-align: center; margin-top: 30px;'>"
                    + "  <a href='http://localhost:9090/blood-bank/login.jsp' style='background-color: #e11d48; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;'>Login for Details</a>"
                    + "</div>"
                    + "<p style='font-size: 0.8em; color: #999; margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; text-align: center;'>Helping each other is the heart of LifeFlow.</p>"
                    + "</div>";
                    
            message.setContent(htmlBody, "text/html");
            Transport.send(message);
            System.out.println("✅ PEER EMERGENCY Email broadcast successfully sent to " + bccEmails.size() + " donors.");
        } catch (Exception e) {
            System.err.println("❌ Failed to broadcast peer emergency email.");
            e.printStackTrace();
        }
    public static void notifyAdminOfNewPendingApproval(String userName, String userEmail, String role) {
        System.out.println("Notifying Admin of new pending approval: " + userEmail);
        
        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #3b82f6; border-radius: 8px;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h1 style='color: #3b82f6; margin: 0;'>Action Required</h1>"
                + "  <p style='color: #666; font-size: 1.1em; margin-top: 5px;'>New account awaiting approval.</p>"
                + "</div>"
                + "<p style='font-size: 1.0em;'>A new <strong>" + role + "</strong> has registered and verified their email address.</p>"
                + "<div style='background: #f8fafc; border: 1px solid #e2e8f0; padding: 20px; border-radius: 6px; margin: 25px 0;'>"
                + "  <p style='margin: 0;'><strong>Name:</strong> " + userName + "</p>"
                + "  <p style='margin: 5px 0 0 0;'><strong>Email:</strong> " + userEmail + "</p>"
                + "  <p style='margin: 5px 0 0 0;'><strong>Account Type:</strong> " + role + "</p>"
                + "</div>"
                + "<p style='line-height: 1.6;'>Please log into the Admin Dashboard to review the registration details and approve or reject the account.</p>"
                + "<div style='text-align: center; margin-top: 30px;'>"
                + "  <a href='http://localhost:9090/blood-bank/login.jsp' style='background-color: #3b82f6; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;'>Go to Admin Panel</a>"
                + "</div>"
                + "</div>";

        sendRawEmail(USERNAME, "ACTION REQUIRED: New " + role + " Approval Pending (" + userName + ")", htmlBody);
    }

    public static void notifyAdminOfEmergency(String bloodGroup, String facilityName, String city, String message, String requesterType) {
        System.out.println("Notifying Admin of " + requesterType + " emergency alert.");
        
        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #ef4444; border-radius: 8px;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h1 style='color: #ef4444; margin: 0;'>GLOBAL ALERT</h1>"
                + "  <p style='color: #666; font-size: 1.1em; margin-top: 5px;'>Emergency broadcast initiated on the network.</p>"
                + "</div>"
                + "<p style='font-size: 1.0em;'>An emergency blood request has been broadcasted by a <strong>" + requesterType + "</strong>.</p>"
                + "<div style='background: #fef2f2; border: 1px solid #fee2e2; padding: 20px; border-radius: 6px; margin: 25px 0;'>"
                + "  <p style='margin: 0;'><strong>Facility/Requester:</strong> " + facilityName + "</p>"
                + "  <p style='margin: 5px 0 0 0;'><strong>Blood Group:</strong> " + bloodGroup + "</p>"
                + "  <p style='margin: 5px 0 0 0;'><strong>City:</strong> " + city + "</p>"
                + "  <p style='margin: 10px 0 0 0; font-size: 0.9em; color: #991b1b;'><em>\"" + (message != null ? message : "No additional message provided.") + "\"</em></p>"
                + "</div>"
                + "<p style='line-height: 1.6;'>No immediate action is required by the administrator, but you may want to monitor the local supply or coordinate with nearby banks if needed.</p>"
                + "</div>";

        sendRawEmail(USERNAME, "SYSTEM ALERT: " + requesterType + " Emergency Broadcast (" + bloodGroup + ")", htmlBody);
    public static void sendBookingConfirmation(String toAddress, String bankName, String appointmentTime) {
        System.out.println("Sending booking confirmation to: " + toAddress);
        
        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #3b82f6; border-radius: 8px;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h1 style='color: #3b82f6; margin: 0;'>Booking Confirmed</h1>"
                + "  <p style='color: #666; font-size: 1.1em; margin-top: 5px;'>Your appointment has been successfully scheduled.</p>"
                + "</div>"
                + "<p style='font-size: 1.0em;'>Thank you for choosing to save a life. Here are your appointment details:</p>"
                + "<div style='background: #f8fafc; border: 1px solid #e2e8f0; padding: 20px; border-radius: 6px; margin: 25px 0;'>"
                + "  <p style='margin: 0;'><strong>Facility:</strong> " + bankName + "</p>"
                + "  <p style='margin: 5px 0 0 0;'><strong>Time:</strong> " + appointmentTime + "</p>"
                + "</div>"
                + "<p style='line-height: 1.6;'>Please remember to stay hydrated and bring a valid ID. If you need to reschedule, you can do so through your dashboard.</p>"
                + "</div>";

        sendRawEmail(toAddress, "LifeFlow - Appointment Confirmation (" + bankName + ")", htmlBody);
    }

    public static void sendDonationThankYou(String toAddress, String donorName, String bankName) {
        System.out.println("Sending donation thank you to: " + toAddress);
        
        String htmlBody = "<div style='font-family: Arial, sans-serif; padding: 30px; color: #333; max-width: 600px; margin: auto; border: 1px solid #ddd; border-top: 5px solid #10b981; border-radius: 8px;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h1 style='color: #10b981; margin: 0;'>Hero Status Achieved!</h1>"
                + "  <p style='color: #666; font-size: 1.1em; margin-top: 5px;'>Your donation has been successfully processed.</p>"
                + "</div>"
                + "<p style='font-size: 1.1em;'>Hi " + donorName + ",</p>"
                + "<p style='line-height: 1.6;'>On behalf of <strong>" + bankName + "</strong> and the LifeFlow network, we want to thank you for your incredible contribution today. Each donation can save up to three lives, and your generosity directly impacts families in our community.</p>"
                + "<div style='background: #f0fdf4; border: 1px solid #d1fae5; padding: 20px; border-radius: 6px; margin: 25px 0; text-align: center;'>"
                + "  <p style='margin: 0; font-size: 1.2em; color: #047857;'><strong>You are a life-saver!</strong></p>"
                + "</div>"
                + "<p style='line-height: 1.6;'>Your recognition points have been updated in your dashboard. We look forward to seeing you again in 3 months!</p>"
                + "</div>";

        sendRawEmail(toAddress, "LifeFlow - Thank You for Your Life-Saving Gift", htmlBody);
    }
}
