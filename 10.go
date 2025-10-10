// Go Example - HTTPサーバーとAPI
package main

import (
  "encoding/json"
  "fmt"
  "log"
  "net/http"
  "sync"
  "time"
)

// Product 構造体
type Product struct {
  ID          int       `json:"id"`
  Name        string    `json:"name"`
  Price       float64   `json:"price"`
  Stock       int       `json:"stock"`
  Category    string    `json:"category"`
  CreatedAt   time.Time `json:"created_at"`
}

// Store 構造体
type Store struct {
  mu       sync.RWMutex
  products map[int]*Product
  nextID   int
}

// NewStore creates a new store
func NewStore() *Store {
  return &Store{
    products: make(map[int]*Product),
    nextID:   1,
  }
}

// AddProduct adds a new product
func (s *Store) AddProduct(name string, price float64, stock int, category string) *Product {
  s.mu.Lock()
  defer s.mu.Unlock()
  
  product := &Product{
    ID:        s.nextID,
    Name:      name,
    Price:     price,
    Stock:     stock,
    Category:  category,
    CreatedAt: time.Now(),
  }
  
  s.products[s.nextID] = product
  s.nextID++
  
  fmt.Printf("✓ Product added: %s (ID: %d)\n", name, product.ID)
  return product
}

// GetProduct gets a product by ID
func (s *Store) GetProduct(id int) (*Product, error) {
  s.mu.RLock()
  defer s.mu.RUnlock()
  
  product, exists := s.products[id]
  if !exists {
    return nil, fmt.Errorf("product not found: ID %d", id)
  }
  
  return product, nil
}

// GetAllProducts returns all products
func (s *Store) GetAllProducts() []*Product {
  s.mu.RLock()
  defer s.mu.RUnlock()
  
  products := make([]*Product, 0, len(s.products))
  for _, p := range s.products {
    products = append(products, p)
  }
  
  return products
}

// UpdateStock updates product stock
func (s *Store) UpdateStock(id int, quantity int) error {
  s.mu.Lock()
  defer s.mu.Unlock()
  
  product, exists := s.products[id]
  if !exists {
    return fmt.Errorf("product not found: ID %d", id)
  }
  
  product.Stock += quantity
  fmt.Printf("✓ Stock updated: %s (Stock: %d)\n", product.Name, product.Stock)
  
  return nil
}

// Server 構造体
type Server struct {
  store *Store
}

// NewServer creates a new server
func NewServer(store *Store) *Server {
  return &Server{store: store}
}

// HandleProducts handles /products endpoint
func (s *Server) HandleProducts(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "application/json")
  
  switch r.Method {
  case http.MethodGet:
    products := s.store.GetAllProducts()
    json.NewEncoder(w).Encode(products)
    
  case http.MethodPost:
    var req struct {
      Name     string  `json:"name"`
      Price    float64 `json:"price"`
      Stock    int     `json:"stock"`
      Category string  `json:"category"`
    }
    
    if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
      http.Error(w, err.Error(), http.StatusBadRequest)
      return
    }
    
    product := s.store.AddProduct(req.Name, req.Price, req.Stock, req.Category)
    json.NewEncoder(w).Encode(product)
    
  default:
    http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
  }
}

// HandleHealth handles /health endpoint
func (s *Server) HandleHealth(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "application/json")
  
  response := map[string]interface{}{
    "status":  "healthy",
    "time":    time.Now().Format(time.RFC3339),
    "products": len(s.store.GetAllProducts()),
  }
  
  json.NewEncoder(w).Encode(response)
}

// LoggingMiddleware logs HTTP requests
func LoggingMiddleware(next http.HandlerFunc) http.HandlerFunc {
  return func(w http.ResponseWriter, r *http.Request) {
    start := time.Now()
    
    log.Printf("%s %s - Start", r.Method, r.URL.Path)
    next(w, r)
    log.Printf("%s %s - Completed in %v", r.Method, r.URL.Path, time.Since(start))
  }
}

// displayProducts displays all products in console
func displayProducts(store *Store) {
  products := store.GetAllProducts()
  
  fmt.Println("\n=== Product List ===")
  for _, p := range products {
    fmt.Printf("[%d] %s\n", p.ID, p.Name)
    fmt.Printf("    Price: ¥%.2f | Stock: %d | Category: %s\n", p.Price, p.Stock, p.Category)
    fmt.Printf("    Created: %s\n", p.CreatedAt.Format("2006-01-02 15:04:05"))
    fmt.Println()
  }
  fmt.Println("====================\n")
}

func main() {
  fmt.Println("=== E-Commerce API Server ===\n")
  
  // Create store and add initial products
  store := NewStore()
  
  store.AddProduct("Laptop", 89800, 10, "Electronics")
  store.AddProduct("Mouse", 2980, 50, "Accessories")
  store.AddProduct("Keyboard", 5980, 30, "Accessories")
  store.AddProduct("Monitor", 29800, 15, "Electronics")
  
  // Display products
  displayProducts(store)
  
  // Create server
  server := NewServer(store)
  
  // Setup routes
  http.HandleFunc("/products", LoggingMiddleware(server.HandleProducts))
  http.HandleFunc("/health", LoggingMiddleware(server.HandleHealth))
  
  // Start server
  port := ":8080"
  fmt.Printf("Server starting on http://localhost%s\n", port)
  fmt.Println("Endpoints:")
  fmt.Println("  GET  /products - List all products")
  fmt.Println("  POST /products - Add new product")
  fmt.Println("  GET  /health   - Health check")
  fmt.Println("\nPress Ctrl+C to stop")
  
  // Note: In a real application, this would start the server
  // log.Fatal(http.ListenAndServe(port, nil))
  
  // For demo purposes, we'll just simulate some operations
  fmt.Println("\n=== Simulating Operations ===")
  
  // Update stock
  store.UpdateStock(1, 5)
  store.UpdateStock(2, -10)
  
  // Get single product
  if product, err := store.GetProduct(1); err == nil {
    fmt.Printf("\nFound product: %s (¥%.2f)\n", product.Name, product.Price)
  }
  
  fmt.Println("\nServer demo completed.")
}

