// Java Example - ユーザー管理システム
package com.example.usermanagement;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * ユーザー管理システムのメインクラス
 * @author Developer
 * @version 1.0
 */
public class UserManagementSystem {
    
    private List<User> users;
    DatabaseConnection dbConnection;  // package-private for main access
    
    public UserManagementSystem(String dbUrl) {
        this.users = new ArrayList<>();
        this.dbConnection = new DatabaseConnection(dbUrl);
    }
    
    /**
     * 新しいユーザーを登録
     * @param name ユーザー名
     * @param email メールアドレス
     * @return 登録されたユーザー
     */
    public User registerUser(String name, String email) {
        if (name == null || email == null) {
            throw new IllegalArgumentException("名前とメールアドレスは必須です");
        }
        
        User newUser = new User(generateUserId(), name, email);
        users.add(newUser);
        
        System.out.println("ユーザー登録完了: " + newUser.getName());
        return newUser;
    }
    
    /**
     * ユーザーIDでユーザーを検索
     * @param userId ユーザーID
     * @return Optional<User>
     */
    public Optional<User> findUserById(int userId) {
        return users.stream()
                   .filter(user -> user.getId() == userId)
                   .findFirst();
    }
    
    /**
     * すべてのユーザーを取得
     * @return ユーザーリスト
     */
    public List<User> getAllUsers() {
        return new ArrayList<>(users);
    }
    
    private int generateUserId() {
        return users.size() + 1;
    }
    
    public static void main(String[] args) {
        System.out.println("=== ユーザー管理システム ===\n");
        
        UserManagementSystem system = new UserManagementSystem("jdbc:mysql://localhost:3306/userdb");
        
        // データベース接続
        system.dbConnection.connect();
        
        // ユーザー登録
        System.out.println("\n--- ユーザー登録 ---");
        User user1 = system.registerUser("田中太郎", "tanaka@example.com");
        User user2 = system.registerUser("佐藤花子", "sato@example.com");
        User user3 = system.registerUser("鈴木一郎", "suzuki@example.com");
        
        // ユーザー検索
        System.out.println("\n--- ユーザー検索 ---");
        Optional<User> foundUser = system.findUserById(1);
        foundUser.ifPresent(user -> 
            System.out.println("見つかったユーザー: " + user.getName())
        );
        
        // 全ユーザー表示
        System.out.println("\n--- 全ユーザー一覧 ---");
        for (User user : system.getAllUsers()) {
            System.out.println(user);
        }
        
        // データベース切断
        System.out.println();
        system.dbConnection.disconnect();
        
        System.out.println("\n=== システム終了 ===");
    }
}

/**
 * ユーザークラス
 */
class User {
    private int id;
    private String name;
    private String email;
    private LocalDateTime createdAt;
    
    public User(int id, String name, String email) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.createdAt = LocalDateTime.now();
    }
    
    public int getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    
    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        return String.format("User[id=%d, name=%s, email=%s, created=%s]",
                           id, name, email, createdAt.format(formatter));
    }
}

class DatabaseConnection {
    private String url;
    private boolean connected;
    
    public DatabaseConnection(String url) {
        this.url = url;
        this.connected = false;
    }
    
    public void connect() {
        System.out.println("データベースに接続しました: " + url);
        this.connected = true;
    }
    
    public void disconnect() {
        System.out.println("データベース接続を切断しました");
        this.connected = false;
    }
    
    public boolean isConnected() {
        return connected;
    }
}