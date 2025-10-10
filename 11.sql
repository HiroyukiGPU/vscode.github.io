-- SQL Example - ECサイトデータベース設計とクエリ

-- データベースの作成
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ユーザーテーブル
CREATE TABLE IF NOT EXISTS users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  full_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_active BOOLEAN DEFAULT TRUE,
  INDEX idx_email (email),
  INDEX idx_username (username)
);

-- 商品カテゴリテーブル
CREATE TABLE IF NOT EXISTS categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(50) NOT NULL UNIQUE,
  description TEXT,
  parent_category_id INT NULL,
  FOREIGN KEY (parent_category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

-- 商品テーブル
CREATE TABLE IF NOT EXISTS products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(100) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  stock_quantity INT NOT NULL DEFAULT 0,
  category_id INT,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  is_available BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
  INDEX idx_category (category_id),
  INDEX idx_price (price),
  CHECK (price >= 0),
  CHECK (stock_quantity >= 0)
);

-- 注文テーブル
CREATE TABLE IF NOT EXISTS orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2) NOT NULL,
  status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
  shipping_address TEXT NOT NULL,
  payment_method VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_status (status),
  INDEX idx_order_date (order_date)
);

-- 注文詳細テーブル
CREATE TABLE IF NOT EXISTS order_details (
  detail_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  subtotal DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT,
  CHECK (quantity > 0),
  CHECK (unit_price >= 0)
);

-- レビューテーブル
CREATE TABLE IF NOT EXISTS reviews (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  user_id INT NOT NULL,
  rating INT NOT NULL,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CHECK (rating >= 1 AND rating <= 5),
  UNIQUE KEY unique_user_product (user_id, product_id)
);

-- サンプルデータの挿入

-- ユーザー
INSERT INTO users (username, email, password_hash, full_name) VALUES
('tanaka_taro', 'tanaka@example.com', 'hashed_password_1', '田中太郎'),
('sato_hanako', 'sato@example.com', 'hashed_password_2', '佐藤花子'),
('suzuki_ichiro', 'suzuki@example.com', 'hashed_password_3', '鈴木一郎');

-- カテゴリ
INSERT INTO categories (category_name, description) VALUES
('電子機器', 'パソコン、タブレット、スマートフォンなど'),
('アクセサリー', 'マウス、キーボード、ケーブルなど'),
('家電', '生活家電、キッチン家電など');

-- 商品
INSERT INTO products (product_name, description, price, stock_quantity, category_id) VALUES
('ノートパソコン', '高性能ノートPC 15.6インチ', 89800.00, 10, 1),
('ワイヤレスマウス', 'Bluetooth対応マウス', 2980.00, 50, 2),
('メカニカルキーボード', 'ゲーミングキーボード RGB対応', 15800.00, 25, 2),
('4Kモニター', '27インチ 4K解像度', 45800.00, 15, 1),
('Webカメラ', 'フルHD 1080p Webカメラ', 8900.00, 30, 1);

-- 注文
INSERT INTO orders (user_id, total_amount, status, shipping_address, payment_method) VALUES
(1, 92780.00, 'delivered', '東京都渋谷区...', 'クレジットカード'),
(2, 18780.00, 'shipped', '大阪府大阪市...', 'コンビニ払い'),
(3, 61600.00, 'processing', '福岡県福岡市...', 'クレジットカード');

-- 注文詳細
INSERT INTO order_details (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 89800.00, 89800.00),
(1, 2, 1, 2980.00, 2980.00),
(2, 3, 1, 15800.00, 15800.00),
(2, 2, 1, 2980.00, 2980.00),
(3, 4, 1, 45800.00, 45800.00),
(3, 3, 1, 15800.00, 15800.00);

-- レビュー
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, '非常に満足しています。性能が素晴らしいです。'),
(2, 1, 4, '使いやすいマウスです。'),
(3, 2, 5, 'タイピングが快適になりました。'),
(1, 3, 4, 'コスパが良いです。');

-- クエリ例

-- 1. すべての商品を価格順に表示
SELECT 
  product_name,
  price,
  stock_quantity,
  category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.is_available = TRUE
ORDER BY price DESC;

-- 2. カテゴリ別の商品数と平均価格
SELECT 
  c.category_name,
  COUNT(p.product_id) AS product_count,
  AVG(p.price) AS avg_price,
  SUM(p.stock_quantity) AS total_stock
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
HAVING product_count > 0
ORDER BY avg_price DESC;

-- 3. ユーザーの注文履歴
SELECT 
  u.full_name,
  o.order_id,
  o.order_date,
  o.total_amount,
  o.status,
  COUNT(od.detail_id) AS item_count
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC;

-- 4. 商品の平均評価とレビュー数
SELECT 
  p.product_name,
  COUNT(r.review_id) AS review_count,
  AVG(r.rating) AS avg_rating,
  p.price
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id
HAVING review_count > 0
ORDER BY avg_rating DESC, review_count DESC;

-- 5. 売上TOP5の商品
SELECT 
  p.product_name,
  SUM(od.quantity) AS total_sold,
  SUM(od.subtotal) AS total_revenue
FROM products p
JOIN order_details od ON p.product_id = od.product_id
JOIN orders o ON od.order_id = o.order_id
WHERE o.status != 'cancelled'
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 5;

-- 6. 在庫が少ない商品（アラート）
SELECT 
  product_name,
  stock_quantity,
  category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE stock_quantity < 20 AND is_available = TRUE
ORDER BY stock_quantity ASC;

-- 7. 月別売上集計
SELECT 
  DATE_FORMAT(order_date, '%Y-%m') AS month,
  COUNT(order_id) AS order_count,
  SUM(total_amount) AS monthly_revenue
FROM orders
WHERE status != 'cancelled'
GROUP BY month
ORDER BY month DESC;

-- ビューの作成
CREATE OR REPLACE VIEW product_sales_summary AS
SELECT 
  p.product_id,
  p.product_name,
  p.price,
  COUNT(DISTINCT od.order_id) AS order_count,
  SUM(od.quantity) AS total_quantity_sold,
  SUM(od.subtotal) AS total_revenue,
  AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id;

-- ストアドプロシージャの例
DELIMITER //
CREATE PROCEDURE GetUserOrderHistory(IN userId INT)
BEGIN
  SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status,
    p.product_name,
    od.quantity,
    od.unit_price
  FROM orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
  WHERE o.user_id = userId
  ORDER BY o.order_date DESC;
END //
DELIMITER ;

-- インデックスの最適化
CREATE INDEX idx_product_category_price ON products(category_id, price);
CREATE INDEX idx_order_user_date ON orders(user_id, order_date);

-- 実行例
-- CALL GetUserOrderHistory(1);

