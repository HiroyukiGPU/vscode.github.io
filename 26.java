// Java Example - シンプルな図書館管理システム
import java.util.ArrayList;

class Book {
    private int id;
    private String title;
    private String author;
    private boolean isBorrowed;
    
    public Book(int id, String title, String author) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.isBorrowed = false;
    }
    
    public void borrow() {
        if (!isBorrowed) {
            isBorrowed = true;
            System.out.println("✓ 「" + title + "」を借りました");
        } else {
            System.out.println("✗ 「" + title + "」は貸出中です");
        }
    }
    
    public void returnBook() {
        if (isBorrowed) {
            isBorrowed = false;
            System.out.println("✓ 「" + title + "」を返却しました");
        } else {
            System.out.println("✗ この本は借りられていません");
        }
    }
    
    public void display() {
        String status = isBorrowed ? "貸出中" : "在庫あり";
        System.out.println(String.format("[%d] %s - %s (%s)", 
            id, title, author, status));
    }
    
    public int getId() { return id; }
    public String getTitle() { return title; }
    public boolean getIsBorrowed() { return isBorrowed; }
}

class LibrarySystem {
    private ArrayList<Book> books;
    
    public LibrarySystem() {
        books = new ArrayList<>();
        initializeBooks();
    }
    
    private void initializeBooks() {
        books.add(new Book(1, "Javaプログラミング入門", "山田太郎"));
        books.add(new Book(2, "アルゴリズムとデータ構造", "佐藤花子"));
        books.add(new Book(3, "デザインパターン", "鈴木一郎"));
        books.add(new Book(4, "Webアプリケーション開発", "田中次郎"));
        books.add(new Book(5, "データベース設計", "高橋美咲"));
    }
    
    public void displayAllBooks() {
        System.out.println("\n=== 蔵書一覧 ===");
        for (Book book : books) {
            book.display();
        }
        System.out.println();
    }
    
    public void borrowBook(int id) {
        for (Book book : books) {
            if (book.getId() == id) {
                book.borrow();
                return;
            }
        }
        System.out.println("✗ 本が見つかりません");
    }
    
    public void returnBook(int id) {
        for (Book book : books) {
            if (book.getId() == id) {
                book.returnBook();
                return;
            }
        }
        System.out.println("✗ 本が見つかりません");
    }
    
    public void searchByTitle(String keyword) {
        System.out.println("\n=== 検索結果: \"" + keyword + "\" ===");
        boolean found = false;
        
        for (Book book : books) {
            if (book.getTitle().contains(keyword)) {
                book.display();
                found = true;
            }
        }
        
        if (!found) {
            System.out.println("該当する本が見つかりませんでした");
        }
        System.out.println();
    }
    
    public ArrayList<Book> getBooks() {
        return books;
    }
}

class Main {
    public static void main(String[] args) {
        System.out.println("╔════════════════════════════════╗");
        System.out.println("║   図書館管理システム v1.0     ║");
        System.out.println("╚════════════════════════════════╝\n");
        
        LibrarySystem library = new LibrarySystem();
        
        // すべての本を表示
        library.displayAllBooks();
        
        // 本を借りる
        System.out.println("--- 貸出処理 ---");
        library.borrowBook(1);
        library.borrowBook(3);
        library.borrowBook(1);  // すでに貸出中
        System.out.println();
        
        // 状態確認
        library.displayAllBooks();
        
        // 本を返却
        System.out.println("--- 返却処理 ---");
        library.returnBook(1);
        library.returnBook(5);  // 借りていない本
        System.out.println();
        
        // 状態確認
        library.displayAllBooks();
        
        // 検索機能
        library.searchByTitle("プログラミング");
        library.searchByTitle("データ");
        
        // 統計情報
        int borrowedCount = 0;
        for (Book book : library.getBooks()) {
            if (book.getIsBorrowed()) {
                borrowedCount++;
            }
        }
        
        System.out.println("=== 統計情報 ===");
        System.out.println("総蔵書数: " + library.getBooks().size() + "冊");
        System.out.println("貸出中: " + borrowedCount + "冊");
        System.out.println("在庫あり: " + (library.getBooks().size() - borrowedCount) + "冊");
        System.out.println("\n✓ システムを終了しました");
    }
}
