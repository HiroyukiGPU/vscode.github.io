' Visual Basic Example - 在庫管理システム
Imports System
Imports System.Collections.Generic
Imports System.Linq

Module InventoryManagementSystem
  
  ' 商品クラス
  Public Class Product
    Public Property ProductId As Integer
    Public Property ProductName As String
    Public Property Category As String
    Public Property Price As Decimal
    Public Property StockQuantity As Integer
    Public Property ReorderLevel As Integer
    Public Property LastUpdated As Date
    
    Public Sub New(id As Integer, name As String, category As String, price As Decimal, stock As Integer, reorder As Integer)
      ProductId = id
      ProductName = name
      Category = category
      Price = price
      StockQuantity = stock
      ReorderLevel = reorder
      LastUpdated = Date.Now
    End Sub
    
    Public Function IsLowStock() As Boolean
      Return StockQuantity <= ReorderLevel
    End Function
    
    Public Function GetTotalValue() As Decimal
      Return Price * StockQuantity
    End Function
    
    Public Sub Display()
      Console.WriteLine($"[{ProductId}] {ProductName}")
      Console.WriteLine($"    カテゴリ: {Category}")
      Console.WriteLine($"    価格: ¥{Price:N0}")
      Console.WriteLine($"    在庫数: {StockQuantity}個")
      Console.WriteLine($"    発注点: {ReorderLevel}個")
      
      If IsLowStock() Then
        Console.WriteLine("    ⚠️ 在庫が少なくなっています")
      End If
      
      Console.WriteLine()
    End Sub
    
    Public Overrides Function ToString() As String
      Return $"{ProductName} (在庫: {StockQuantity}個)"
    End Function
  End Class
  
  ' 在庫取引クラス
  Public Class Transaction
    Public Property TransactionId As Integer
    Public Property ProductId As Integer
    Public Property TransactionType As String ' "入庫" または "出庫"
    Public Property Quantity As Integer
    Public Property TransactionDate As Date
    Public Property Note As String
    
    Public Sub New(id As Integer, productId As Integer, type As String, quantity As Integer, note As String)
      TransactionId = id
      ProductId = productId
      TransactionType = type
      Quantity = quantity
      TransactionDate = Date.Now
      Me.Note = note
    End Sub
    
    Public Sub Display()
      Dim arrow As String = If(TransactionType = "入庫", "⬆️", "⬇️")
      Console.WriteLine($"{arrow} [{TransactionId}] {TransactionType}: {Quantity}個")
      Console.WriteLine($"    商品ID: {ProductId}")
      Console.WriteLine($"    日時: {TransactionDate:yyyy/MM/dd HH:mm}")
      Console.WriteLine($"    備考: {Note}")
      Console.WriteLine()
    End Sub
  End Class
  
  ' 在庫管理マネージャークラス
  Public Class InventoryManager
    Private products As List(Of Product)
    Private transactions As List(Of Transaction)
    Private nextProductId As Integer
    Private nextTransactionId As Integer
    
    Public Sub New()
      products = New List(Of Product)()
      transactions = New List(Of Transaction)()
      nextProductId = 1
      nextTransactionId = 1
      
      Console.WriteLine("✓ 在庫管理システムを初期化しました")
    End Sub
    
    ' 商品を追加
    Public Function AddProduct(name As String, category As String, price As Decimal, stock As Integer, reorder As Integer) As Product
      Dim product As New Product(nextProductId, name, category, price, stock, reorder)
      products.Add(product)
      nextProductId += 1
      
      Console.WriteLine($"✓ 商品を追加しました: {name}")
      Return product
    End Function
    
    ' 商品を検索
    Public Function FindProduct(productId As Integer) As Product
      Return products.FirstOrDefault(Function(p) p.ProductId = productId)
    End Function
    
    ' 入庫処理
    Public Sub ReceiveStock(productId As Integer, quantity As Integer, note As String)
      Dim product = FindProduct(productId)
      
      If product Is Nothing Then
        Console.WriteLine("✗ 商品が見つかりません")
        Return
      End If
      
      product.StockQuantity += quantity
      product.LastUpdated = Date.Now
      
      Dim transaction As New Transaction(nextTransactionId, productId, "入庫", quantity, note)
      transactions.Add(transaction)
      nextTransactionId += 1
      
      Console.WriteLine($"✓ {product.ProductName} を {quantity}個 入庫しました")
    End Sub
    
    ' 出庫処理
    Public Sub ShipStock(productId As Integer, quantity As Integer, note As String)
      Dim product = FindProduct(productId)
      
      If product Is Nothing Then
        Console.WriteLine("✗ 商品が見つかりません")
        Return
      End If
      
      If product.StockQuantity < quantity Then
        Console.WriteLine($"✗ 在庫不足です (在庫: {product.StockQuantity}個)")
        Return
      End If
      
      product.StockQuantity -= quantity
      product.LastUpdated = Date.Now
      
      Dim transaction As New Transaction(nextTransactionId, productId, "出庫", quantity, note)
      transactions.Add(transaction)
      nextTransactionId += 1
      
      Console.WriteLine($"✓ {product.ProductName} を {quantity}個 出庫しました")
    End Sub
    
    ' すべての商品を表示
    Public Sub DisplayAllProducts()
      Console.WriteLine()
      Console.WriteLine("=== 商品一覧 ===")
      Console.WriteLine()
      
      If products.Count = 0 Then
        Console.WriteLine("商品がありません")
        Return
      End If
      
      For Each product In products
        product.Display()
      Next
      
      Console.WriteLine("================")
      Console.WriteLine()
    End Sub
    
    ' 在庫が少ない商品を表示
    Public Sub DisplayLowStockProducts()
      Console.WriteLine()
      Console.WriteLine("=== 在庫が少ない商品 ===")
      Console.WriteLine()
      
      Dim lowStockProducts = products.Where(Function(p) p.IsLowStock()).ToList()
      
      If lowStockProducts.Count = 0 Then
        Console.WriteLine("該当する商品はありません")
      Else
        For Each product In lowStockProducts
          Console.WriteLine($"⚠️ {product.ProductName} (在庫: {product.StockQuantity}個, 発注点: {product.ReorderLevel}個)")
        Next
      End If
      
      Console.WriteLine()
      Console.WriteLine("========================")
      Console.WriteLine()
    End Sub
    
    ' カテゴリ別の集計
    Public Sub DisplayCategorySummary()
      Console.WriteLine()
      Console.WriteLine("=== カテゴリ別集計 ===")
      Console.WriteLine()
      
      Dim categoryGroups = products.GroupBy(Function(p) p.Category)
      
      For Each group In categoryGroups
        Dim totalValue = group.Sum(Function(p) p.GetTotalValue())
        Dim totalQty = group.Sum(Function(p) p.StockQuantity)
        
        Console.WriteLine($"[{group.Key}]")
        Console.WriteLine($"  商品数: {group.Count()}個")
        Console.WriteLine($"  総在庫数: {totalQty}個")
        Console.WriteLine($"  総在庫価値: ¥{totalValue:N0}")
        Console.WriteLine()
      Next
      
      Console.WriteLine("======================")
      Console.WriteLine()
    End Sub
    
    ' 取引履歴を表示
    Public Sub DisplayTransactionHistory(limit As Integer)
      Console.WriteLine()
      Console.WriteLine($"=== 最近の取引履歴 (最新{limit}件) ===")
      Console.WriteLine()
      
      Dim recentTransactions = transactions.OrderByDescending(Function(t) t.TransactionDate).Take(limit)
      
      For Each transaction In recentTransactions
        transaction.Display()
      Next
      
      Console.WriteLine("====================================")
      Console.WriteLine()
    End Sub
    
    ' 統計情報を表示
    Public Sub DisplayStatistics()
      Console.WriteLine()
      Console.WriteLine("=== 統計情報 ===")
      Console.WriteLine()
      Console.WriteLine($"総商品数: {products.Count}個")
      Console.WriteLine($"総取引数: {transactions.Count}件")
      
      Dim totalValue = products.Sum(Function(p) p.GetTotalValue())
      Console.WriteLine($"総在庫価値: ¥{totalValue:N0}")
      
      Dim lowStockCount = products.Count(Function(p) p.IsLowStock())
      Console.WriteLine($"在庫警告: {lowStockCount}個")
      
      Console.WriteLine()
      Console.WriteLine("================")
      Console.WriteLine()
    End Sub
  End Class
  
  ' メイン処理
  Sub Main()
    Console.WriteLine(New String("="c, 60))
    Console.WriteLine("  在庫管理システム - Visual Basic Edition")
    Console.WriteLine(New String("="c, 60))
    Console.WriteLine()
    
    Dim manager As New InventoryManager()
    
    ' 商品を追加
    manager.AddProduct("ノートパソコン", "電子機器", 89800, 15, 5)
    manager.AddProduct("マウス", "周辺機器", 2980, 50, 10)
    manager.AddProduct("キーボード", "周辺機器", 5980, 30, 8)
    manager.AddProduct("モニター", "電子機器", 29800, 20, 5)
    manager.AddProduct("USBケーブル", "アクセサリー", 980, 100, 20)
    
    ' すべての商品を表示
    manager.DisplayAllProducts()
    
    ' 在庫操作
    Console.WriteLine("=== 在庫操作 ===")
    Console.WriteLine()
    manager.ReceiveStock(1, 10, "定期発注")
    manager.ShipStock(2, 15, "営業部へ出荷")
    manager.ShipStock(3, 5, "開発部へ出荷")
    Console.WriteLine()
    
    ' 取引履歴を表示
    manager.DisplayTransactionHistory(5)
    
    ' 在庫が少ない商品を表示
    manager.DisplayLowStockProducts()
    
    ' カテゴリ別集計
    manager.DisplayCategorySummary()
    
    ' 統計情報
    manager.DisplayStatistics()
    
    Console.WriteLine(New String("="c, 60))
    Console.WriteLine("✓ プログラムが完了しました")
    Console.WriteLine(New String("="c, 60))
    
    ' プログラム終了を待機
    Console.WriteLine()
    Console.WriteLine("Enterキーを押して終了...")
    ' Console.ReadLine()  ' コメントアウト - デモ用
  End Sub
  
End Module

