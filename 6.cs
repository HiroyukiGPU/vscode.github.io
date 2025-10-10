// C# Example - ショッピングカートシステム
using System;
using System.Collections.Generic;
using System.Linq;

namespace ShoppingCartSystem
{
  // 商品クラス
  public class Product
  {
    public int Id { get; set; }
    public string Name { get; set; }
    public decimal Price { get; set; }
    public string Category { get; set; }
    public int Stock { get; set; }
    
    public Product(int id, string name, decimal price, string category, int stock)
    {
      Id = id;
      Name = name;
      Price = price;
      Category = category;
      Stock = stock;
    }
    
    public override string ToString()
    {
      return $"[{Id}] {Name} - ¥{Price:N0} ({Category}) 在庫: {Stock}";
    }
  }
  
  // カート商品クラス
  public class CartItem
  {
    public Product Product { get; set; }
    public int Quantity { get; set; }
    
    public decimal Subtotal => Product.Price * Quantity;
    
    public CartItem(Product product, int quantity)
    {
      Product = product;
      Quantity = quantity;
    }
  }
  
  // ショッピングカートクラス
  public class ShoppingCart
  {
    private List<CartItem> items = new List<CartItem>();
    
    public void AddItem(Product product, int quantity)
    {
      if (quantity <= 0)
      {
        Console.WriteLine("数量は1以上を指定してください");
        return;
      }
      
      if (product.Stock < quantity)
      {
        Console.WriteLine($"在庫不足: {product.Name} の在庫は {product.Stock} 個です");
        return;
      }
      
      var existingItem = items.FirstOrDefault(i => i.Product.Id == product.Id);
      
      if (existingItem != null)
      {
        existingItem.Quantity += quantity;
        Console.WriteLine($"{product.Name} の数量を {existingItem.Quantity} に更新しました");
      }
      else
      {
        items.Add(new CartItem(product, quantity));
        Console.WriteLine($"{product.Name} をカートに追加しました（数量: {quantity}）");
      }
    }
    
    public void RemoveItem(int productId)
    {
      var item = items.FirstOrDefault(i => i.Product.Id == productId);
      if (item != null)
      {
        items.Remove(item);
        Console.WriteLine($"{item.Product.Name} をカートから削除しました");
      }
      else
      {
        Console.WriteLine("商品が見つかりません");
      }
    }
    
    public void DisplayCart()
    {
      if (items.Count == 0)
      {
        Console.WriteLine("カートは空です");
        return;
      }
      
      Console.WriteLine("\n=== カートの中身 ===");
      foreach (var item in items)
      {
        Console.WriteLine($"{item.Product.Name} x{item.Quantity} = ¥{item.Subtotal:N0}");
      }
      
      Console.WriteLine($"\n小計: ¥{GetSubtotal():N0}");
      Console.WriteLine($"消費税: ¥{GetTax():N0}");
      Console.WriteLine($"合計: ¥{GetTotal():N0}");
      Console.WriteLine("==================\n");
    }
    
    public decimal GetSubtotal()
    {
      return items.Sum(i => i.Subtotal);
    }
    
    public decimal GetTax()
    {
      return GetSubtotal() * 0.1m; // 消費税10%
    }
    
    public decimal GetTotal()
    {
      return GetSubtotal() + GetTax();
    }
    
    public void Clear()
    {
      items.Clear();
      Console.WriteLine("カートをクリアしました");
    }
  }
  
  // 商品管理クラス
  public class ProductManager
  {
    private List<Product> products = new List<Product>();
    
    public ProductManager()
    {
      InitializeProducts();
    }
    
    private void InitializeProducts()
    {
      products.Add(new Product(1, "ノートパソコン", 89800, "電子機器", 10));
      products.Add(new Product(2, "ワイヤレスマウス", 2980, "周辺機器", 50));
      products.Add(new Product(3, "キーボード", 5980, "周辺機器", 30));
      products.Add(new Product(4, "モニター", 29800, "電子機器", 15));
      products.Add(new Product(5, "USBケーブル", 980, "アクセサリー", 100));
    }
    
    public void DisplayProducts()
    {
      Console.WriteLine("\n=== 商品一覧 ===");
      foreach (var product in products)
      {
        Console.WriteLine(product);
      }
      Console.WriteLine("================\n");
    }
    
    public Product GetProductById(int id)
    {
      return products.FirstOrDefault(p => p.Id == id);
    }
    
    public List<Product> SearchByCategory(string category)
    {
      return products.Where(p => p.Category == category).ToList();
    }
  }
  
  // メインプログラム
  class Program
  {
    static void Main(string[] args)
    {
      Console.WriteLine("=== ショッピングカートシステム ===\n");
      
      var productManager = new ProductManager();
      var cart = new ShoppingCart();
      
      // 商品一覧を表示
      productManager.DisplayProducts();
      
      // 商品をカートに追加
      var laptop = productManager.GetProductById(1);
      var mouse = productManager.GetProductById(2);
      var keyboard = productManager.GetProductById(3);
      
      if (laptop != null)
        cart.AddItem(laptop, 1);
      
      if (mouse != null)
        cart.AddItem(mouse, 2);
      
      if (keyboard != null)
        cart.AddItem(keyboard, 1);
      
      // カートの内容を表示
      cart.DisplayCart();
      
      // カテゴリで検索
      Console.WriteLine("=== 周辺機器カテゴリの商品 ===");
      var peripherals = productManager.SearchByCategory("周辺機器");
      foreach (var product in peripherals)
      {
        Console.WriteLine(product);
      }
      Console.WriteLine();
      
      // 商品を削除
      cart.RemoveItem(2);
      cart.DisplayCart();
      
      Console.WriteLine("お買い物ありがとうございました！");
    }
  }
}

