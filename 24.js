// JavaScript Example - eコマース管理システム
class Product {
  constructor(id, name, price, category, stock) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.category = category;
    this.stock = stock;
    this.createdAt = new Date();
  }
  
  isInStock() {
    return this.stock > 0;
  }
  
  updateStock(quantity) {
    this.stock += quantity;
    console.log(`✓ ${this.name} の在庫を更新: ${this.stock}個`);
  }
  
  display() {
    console.log(`[${this.id}] ${this.name}`);
    console.log(`  価格: ¥${this.price.toLocaleString()}`);
    console.log(`  カテゴリ: ${this.category}`);
    console.log(`  在庫: ${this.stock}個`);
    console.log('');
  }
}

class Customer {
  constructor(id, name, email) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.orders = [];
    this.totalSpent = 0;
  }
  
  addOrder(order) {
    this.orders.push(order);
    this.totalSpent += order.getTotalAmount();
  }
  
  getOrderHistory() {
    return this.orders;
  }
  
  display() {
    console.log(`👤 ${this.name}`);
    console.log(`  ID: ${this.id}`);
    console.log(`  Email: ${this.email}`);
    console.log(`  注文数: ${this.orders.length}`);
    console.log(`  総購入額: ¥${this.totalSpent.toLocaleString()}`);
    console.log('');
  }
}

class OrderItem {
  constructor(product, quantity) {
    this.product = product;
    this.quantity = quantity;
  }
  
  getSubtotal() {
    return this.product.price * this.quantity;
  }
}

class Order {
  static nextId = 1;
  
  constructor(customer) {
    this.id = Order.nextId++;
    this.customer = customer;
    this.items = [];
    this.status = 'pending';
    this.createdAt = new Date();
  }
  
  addItem(product, quantity) {
    if (product.stock < quantity) {
      console.log(`✗ ${product.name} の在庫が不足しています`);
      return false;
    }
    
    const item = new OrderItem(product, quantity);
    this.items.push(item);
    product.updateStock(-quantity);
    
    console.log(`✓ ${product.name} x${quantity} をカートに追加しました`);
    return true;
  }
  
  getTotalAmount() {
    return this.items.reduce((total, item) => total + item.getSubtotal(), 0);
  }
  
  confirm() {
    if (this.items.length === 0) {
      console.log('✗ カートが空です');
      return false;
    }
    
    this.status = 'confirmed';
    this.customer.addOrder(this);
    
    console.log(`✓ 注文 #${this.id} を確定しました`);
    return true;
  }
  
  display() {
    console.log(`\n=== 注文 #${this.id} ===`);
    console.log(`顧客: ${this.customer.name}`);
    console.log(`ステータス: ${this.status}`);
    console.log(`注文日時: ${this.createdAt.toLocaleString('ja-JP')}`);
    console.log('\n商品:');
    
    this.items.forEach((item, index) => {
      const subtotal = item.getSubtotal();
      console.log(`  ${index + 1}. ${item.product.name} x${item.quantity}`);
      console.log(`     単価: ¥${item.product.price.toLocaleString()} | 小計: ¥${subtotal.toLocaleString()}`);
    });
    
    const total = this.getTotalAmount();
    const tax = Math.floor(total * 0.1);
    const grandTotal = total + tax;
    
    console.log(`\n小計: ¥${total.toLocaleString()}`);
    console.log(`消費税(10%): ¥${tax.toLocaleString()}`);
    console.log(`合計: ¥${grandTotal.toLocaleString()}`);
    console.log('=' + '='.repeat(30));
  }
}

class ECommerceSystem {
  constructor() {
    this.products = new Map();
    this.customers = new Map();
    this.orders = [];
    this.nextProductId = 1;
    this.nextCustomerId = 1;
  }
  
  addProduct(name, price, category, stock) {
    const product = new Product(
      this.nextProductId++,
      name,
      price,
      category,
      stock
    );
    
    this.products.set(product.id, product);
    console.log(`✓ 商品を追加しました: ${name}`);
    return product;
  }
  
  registerCustomer(name, email) {
    const customer = new Customer(
      this.nextCustomerId++,
      name,
      email
    );
    
    this.customers.set(customer.id, customer);
    console.log(`✓ 顧客を登録しました: ${name}`);
    return customer;
  }
  
  createOrder(customerId) {
    const customer = this.customers.get(customerId);
    if (!customer) {
      console.log('✗ 顧客が見つかりません');
      return null;
    }
    
    const order = new Order(customer);
    this.orders.push(order);
    return order;
  }
  
  displayProducts() {
    console.log('\n' + '='.repeat(60));
    console.log('  商品一覧');
    console.log('='.repeat(60) + '\n');
    
    this.products.forEach(product => {
      product.display();
    });
  }
  
  displayCustomers() {
    console.log('\n' + '='.repeat(60));
    console.log('  顧客一覧');
    console.log('='.repeat(60) + '\n');
    
    this.customers.forEach(customer => {
      customer.display();
    });
  }
  
  getProductsByCategory(category) {
    return Array.from(this.products.values())
      .filter(p => p.category === category);
  }
  
  getTopCustomers(limit = 5) {
    return Array.from(this.customers.values())
      .sort((a, b) => b.totalSpent - a.totalSpent)
      .slice(0, limit);
  }
  
  getSalesReport() {
    const totalSales = this.orders.reduce(
      (total, order) => total + order.getTotalAmount(),
      0
    );
    
    const totalOrders = this.orders.length;
    const averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0;
    
    console.log('\n' + '='.repeat(60));
    console.log('  売上レポート');
    console.log('='.repeat(60));
    console.log(`総売上: ¥${totalSales.toLocaleString()}`);
    console.log(`注文数: ${totalOrders}件`);
    console.log(`平均注文額: ¥${Math.floor(averageOrderValue).toLocaleString()}`);
    console.log(`登録顧客数: ${this.customers.size}人`);
    console.log(`商品数: ${this.products.size}個`);
    console.log('='.repeat(60) + '\n');
  }
}

// メイン処理
function main() {
  console.log('='.repeat(60));
  console.log('  eコマース管理システム');
  console.log('='.repeat(60));
  console.log('');
  
  const system = new ECommerceSystem();
  
  // 商品を追加
  console.log('=== 商品登録 ===\n');
  const laptop = system.addProduct('ノートパソコン', 89800, '電子機器', 10);
  const mouse = system.addProduct('ワイヤレスマウス', 2980, '周辺機器', 50);
  const keyboard = system.addProduct('メカニカルキーボード', 15800, '周辺機器', 30);
  const monitor = system.addProduct('4Kモニター', 45800, '電子機器', 15);
  const cable = system.addProduct('USBケーブル', 980, 'アクセサリー', 100);
  console.log('');
  
  // 顧客を登録
  console.log('=== 顧客登録 ===\n');
  const customer1 = system.registerCustomer('田中太郎', 'tanaka@example.com');
  const customer2 = system.registerCustomer('佐藤花子', 'sato@example.com');
  const customer3 = system.registerCustomer('鈴木一郎', 'suzuki@example.com');
  console.log('');
  
  // 注文1
  console.log('=== 注文処理 1 ===\n');
  const order1 = system.createOrder(customer1.id);
  if (order1) {
    order1.addItem(laptop, 1);
    order1.addItem(mouse, 1);
    order1.confirm();
    order1.display();
  }
  
  // 注文2
  console.log('\n=== 注文処理 2 ===\n');
  const order2 = system.createOrder(customer2.id);
  if (order2) {
    order2.addItem(keyboard, 1);
    order2.addItem(cable, 2);
    order2.confirm();
    order2.display();
  }
  
  // 注文3
  console.log('\n=== 注文処理 3 ===\n');
  const order3 = system.createOrder(customer3.id);
  if (order3) {
    order3.addItem(monitor, 1);
    order3.addItem(keyboard, 1);
    order3.addItem(mouse, 2);
    order3.confirm();
    order3.display();
  }
  
  // 商品一覧
  system.displayProducts();
  
  // 顧客一覧
  system.displayCustomers();
  
  // カテゴリ別商品検索
  console.log('=== 電子機器カテゴリの商品 ===\n');
  const electronics = system.getProductsByCategory('電子機器');
  electronics.forEach(product => {
    console.log(`- ${product.name} (¥${product.price.toLocaleString()})`);
  });
  console.log('');
  
  // トップ顧客
  console.log('=== トップ顧客 ===\n');
  const topCustomers = system.getTopCustomers(3);
  topCustomers.forEach((customer, index) => {
    console.log(`${index + 1}. ${customer.name} - ¥${customer.totalSpent.toLocaleString()}`);
  });
  console.log('');
  
  // 売上レポート
  system.getSalesReport();
  
  console.log('✓ システムデモが完了しました\n');
}

// プログラム実行
main();

// エクスポート（Node.js用）
if (typeof module !== 'undefined' && module.exports) {
  module.exports = {
    Product,
    Customer,
    Order,
    ECommerceSystem
  };
}

