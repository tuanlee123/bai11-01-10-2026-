package service;

import dao.IUserDao_24162138;
import dao.UserDaoImpl_24162138;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import model.UserModel_24162138;

import java.util.Properties;

public class UserServiceImpl_24162138 implements IUserService_24162138 {
    private IUserDao_24162138 userDao = new UserDaoImpl_24162138();

    @Override
    public UserModel_24162138 login(String email, String password) {
        return userDao.login(email, password);
    }

    @Override
    public boolean checkExistEmail(String email) {
        return userDao.checkExistEmail(email);
    }

    @Override
    public void register(UserModel_24162138 user) {
        userDao.register(user);
    }

    @Override
    public void sendOtpMail(String toEmail, String otp) {
        // Luôn in ra console để test nhanh phòng khi mạng trường chặn cổng SMTP
        System.out.println("==========================================");
        System.out.println("[OTP TEST] Gui den " + toEmail + " | MA OTP LA: " + otp);
        System.out.println("==========================================");

        final String from = "your_email@gmail.com";
        final String appPassword = "your_app_password"; // Mật khẩu ứng dụng 16 ký tự

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, appPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from, "BookStore 24162138", "UTF-8"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Mã xác thực OTP - BookStore - MSSV 24162138");
            
            // Hỗ trợ tiếng Việt UTF-8 không bị lỗi font
            message.setContent(
                "<h3 style='color: #0d6efd;'>Hệ thống BookStore 24162138</h3>" +
                "<p>Mã kích hoạt tài khoản của bạn là: <strong style='font-size: 20px; color: red;'>" + otp + "</strong></p>" +
                "<p>Mã này có hiệu lực trong phiên đăng ký hiện tại.</p>",
                "text/html; charset=UTF-8"
            );

            Transport.send(message);
        } catch (Exception e) {
            System.err.println("Lỗi gửi Email OTP (Kiểm tra lại App Password hoặc mạng): " + e.getMessage());
        }
    }
}