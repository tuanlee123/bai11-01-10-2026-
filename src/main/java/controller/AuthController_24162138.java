package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.UserModel_24162138;
import service.IUserService_24162138;
import service.UserServiceImpl_24162138;

import java.io.IOException;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

@WebServlet(name = "AuthController_24162138", urlPatterns = {"/login", "/register", "/verify-otp", "/logout"})
public class AuthController_24162138 extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IUserService_24162138 userService = new UserServiceImpl_24162138();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        switch (path) {
            case "/login":
                req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
                break;
            case "/register":
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                break;
            case "/verify-otp":
                req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
                break;
            case "/logout":
                HttpSession session = req.getSession(false);
                if (session != null) {
                    session.removeAttribute("user");
                    session.invalidate();
                }
                resp.sendRedirect(req.getContextPath() + "/login");
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/login");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path)) {
            handleRegister(req, resp);
        } else if ("/verify-otp".equals(path)) {
            handleVerifyOtp(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
            return;
        }

        String hashedPassword = hashMD5(password.trim());
        UserModel_24162138 user = userService.login(email.trim(), hashedPassword);

        // Fallback kiểm tra mật khẩu dạng raw text nếu dữ liệu test chưa băm
        if (user == null) {
            user = userService.login(email.trim(), password.trim());
        }

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin/books");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
        } else {
            req.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            req.getRequestDispatcher("/views/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String fullname = req.getParameter("fullname");
        String password = req.getParameter("password");

        if (email == null || fullname == null || password == null ||
            email.trim().isEmpty() || fullname.trim().isEmpty() || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ các thông tin đăng ký!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        if (userService.checkExistEmail(email.trim())) {
            req.setAttribute("error", "Email này đã được sử dụng!");
            req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            return;
        }

        String hashedPassword = hashMD5(password.trim());
        UserModel_24162138 pendingUser = new UserModel_24162138(email.trim(), fullname.trim(), hashedPassword);

        String otp = String.format("%06d", new Random().nextInt(1000000));

        HttpSession session = req.getSession();
        session.setAttribute("pendingUser", pendingUser);
        session.setAttribute("authOtp", otp);

        new Thread(() -> {
            try {
                userService.sendOtpMail(email.trim(), otp);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();

        resp.sendRedirect(req.getContextPath() + "/verify-otp");
    }

    private void handleVerifyOtp(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String inputOtp = req.getParameter("otp");
        HttpSession session = req.getSession(false);
        String sessionOtp = (session != null) ? (String) session.getAttribute("authOtp") : null;
        UserModel_24162138 pendingUser = (session != null) ? (UserModel_24162138) session.getAttribute("pendingUser") : null;

        if (sessionOtp != null && inputOtp != null && sessionOtp.equals(inputOtp.trim()) && pendingUser != null) {
            userService.register(pendingUser);

            session.removeAttribute("authOtp");
            session.removeAttribute("pendingUser");

            session.setAttribute("flashMessage", "Đăng ký tài khoản thành công! Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/login");
        } else {
            req.setAttribute("error", "Mã OTP không hợp lệ hoặc phiên đăng ký đã hết hạn!");
            req.getRequestDispatcher("/views/verify-otp.jsp").forward(req, resp);
        }
    }

    private String hashMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            return input;
        }
    }
}