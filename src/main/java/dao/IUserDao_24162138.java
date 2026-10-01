package dao;

import model.UserModel_24162138;

public interface IUserDao_24162138 {
    UserModel_24162138 login(String email, String password);
    boolean checkExistEmail(String email);
    void register(UserModel_24162138 user);
}