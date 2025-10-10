// D Example - ゲームエンジン（簡易版）
import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.range;
import std.math;

// ベクトル2D構造体
struct Vector2 {
  float x;
  float y;
  
  // 演算子オーバーロード
  Vector2 opBinary(string op)(Vector2 rhs) const {
    static if (op == "+") return Vector2(x + rhs.x, y + rhs.y);
    else static if (op == "-") return Vector2(x - rhs.x, y - rhs.y);
    else static if (op == "*") return Vector2(x * rhs.x, y * rhs.y);
    else static assert(0, "Operator " ~ op ~ " not implemented");
  }
  
  Vector2 opBinary(string op)(float scalar) const {
    static if (op == "*") return Vector2(x * scalar, y * scalar);
    else static if (op == "/") return Vector2(x / scalar, y / scalar);
    else static assert(0, "Operator " ~ op ~ " not implemented");
  }
  
  float magnitude() const {
    return sqrt(x * x + y * y);
  }
  
  Vector2 normalized() const {
    float mag = magnitude();
    if (mag > 0) {
      return Vector2(x / mag, y / mag);
    }
    return Vector2(0, 0);
  }
  
  string toString() const {
    return format("Vector2(%.2f, %.2f)", x, y);
  }
}

// ゲームオブジェクト基底クラス
abstract class GameObject {
  string name;
  Vector2 position;
  Vector2 velocity;
  bool isActive;
  
  this(string name, Vector2 position) {
    this.name = name;
    this.position = position;
    this.velocity = Vector2(0, 0);
    this.isActive = true;
  }
  
  void update(float deltaTime) {
    if (isActive) {
      position = position + velocity * deltaTime;
    }
  }
  
  abstract void display() const;
  
  float distanceTo(GameObject other) const {
    Vector2 diff = position - other.position;
    return diff.magnitude();
  }
}

// プレイヤークラス
class Player : GameObject {
  int health;
  int maxHealth;
  int score;
  
  this(string name, Vector2 position) {
    super(name, position);
    this.maxHealth = 100;
    this.health = maxHealth;
    this.score = 0;
  }
  
  override void display() const {
    writefln("🎮 [PLAYER] %s", name);
    writefln("   位置: %s", position.toString());
    writefln("   HP: %d/%d", health, maxHealth);
    writefln("   スコア: %d", score);
  }
  
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) health = 0;
    
    if (health == 0) {
      writefln("💀 %s が倒れた！", name);
      isActive = false;
    } else {
      writefln("💥 %s は %d のダメージを受けた！", name, damage);
    }
  }
  
  void heal(int amount) {
    health = min(maxHealth, health + amount);
    writefln("💚 %s は %d 回復した！(HP: %d/%d)", name, amount, health, maxHealth);
  }
  
  void addScore(int points) {
    score += points;
    writefln("⭐ スコア +%d (合計: %d)", points, score);
  }
}

// 敵クラス
class Enemy : GameObject {
  int health;
  int attackPower;
  
  this(string name, Vector2 position, int health, int attackPower) {
    super(name, position);
    this.health = health;
    this.attackPower = attackPower;
  }
  
  override void display() const {
    writefln("👾 [ENEMY] %s", name);
    writefln("   位置: %s", position.toString());
    writefln("   HP: %d", health);
    writefln("   攻撃力: %d", attackPower);
  }
  
  void attack(Player player) {
    if (isActive && player.isActive) {
      writefln("⚔️  %s が %s を攻撃！", name, player.name);
      player.takeDamage(attackPower);
    }
  }
  
  void takeDamage(int damage) {
    health -= damage;
    if (health <= 0) {
      health = 0;
      isActive = false;
      writefln("💀 %s を倒した！", name);
    } else {
      writefln("💥 %s に %d のダメージ！", name, damage);
    }
  }
}

// アイテムクラス
class Item : GameObject {
  string itemType;
  int value;
  
  this(string name, Vector2 position, string itemType, int value) {
    super(name, position);
    this.itemType = itemType;
    this.value = value;
  }
  
  override void display() const {
    string icon = itemType == "health" ? "💊" : "⭐";
    writefln("%s [ITEM] %s", icon, name);
    writefln("   位置: %s", position.toString());
    writefln("   タイプ: %s", itemType);
    writefln("   効果: %d", value);
  }
  
  void collect(Player player) {
    if (isActive && player.isActive) {
      if (itemType == "health") {
        player.heal(value);
      } else if (itemType == "score") {
        player.addScore(value);
      }
      
      isActive = false;
      writefln("✓ %s を入手した！", name);
    }
  }
}

// ゲームマネージャー
class GameManager {
  Player player;
  Enemy[] enemies;
  Item[] items;
  bool isRunning;
  
  this() {
    isRunning = false;
  }
  
  void initialize() {
    writeln("=" ~ "=".repeat(59));
    writeln("  Dゲームエンジン - シンプルRPG");
    writeln("=" ~ "=".repeat(59));
    writeln();
    
    // プレイヤー作成
    player = new Player("勇者", Vector2(0, 0));
    
    // 敵を作成
    enemies ~= new Enemy("スライム", Vector2(10, 5), 30, 10);
    enemies ~= new Enemy("ゴブリン", Vector2(20, 10), 50, 15);
    enemies ~= new Enemy("ドラゴン", Vector2(30, 15), 100, 25);
    
    // アイテムを作成
    items ~= new Item("体力ポーション", Vector2(15, 7), "health", 30);
    items ~= new Item("宝箱", Vector2(25, 12), "score", 100);
    
    isRunning = true;
    writeln("✓ ゲームを初期化しました\n");
  }
  
  void displayStatus() {
    writeln("\n" ~ "=" ~ "=".repeat(59));
    writeln("  ゲーム状態");
    writeln("=" ~ "=".repeat(59) ~ "\n");
    
    player.display();
    writeln();
    
    writeln("=== 敵 ===");
    foreach (enemy; enemies.filter!(e => e.isActive)) {
      enemy.display();
      writeln();
    }
    
    writeln("=== アイテム ===");
    foreach (item; items.filter!(i => i.isActive)) {
      item.display();
      writeln();
    }
  }
  
  void update(float deltaTime) {
    if (!isRunning) return;
    
    // すべてのオブジェクトを更新
    player.update(deltaTime);
    
    foreach (enemy; enemies) {
      enemy.update(deltaTime);
    }
    
    foreach (item; items) {
      item.update(deltaTime);
    }
  }
  
  void simulateBattle() {
    writeln("\n" ~ "=" ~ "=".repeat(59));
    writeln("  バトル開始！");
    writeln("=" ~ "=".repeat(59) ~ "\n");
    
    foreach (enemy; enemies) {
      if (!enemy.isActive || !player.isActive) continue;
      
      writefln("\n=== %s との戦闘 ===\n", enemy.name);
      
      // 簡単な戦闘シミュレーション
      while (enemy.health > 0 && player.health > 0) {
        // プレイヤーの攻撃
        int playerDamage = 20;
        writefln("⚔️  %s の攻撃！", player.name);
        enemy.takeDamage(playerDamage);
        
        if (enemy.health <= 0) {
          player.addScore(enemy.health);
          break;
        }
        
        // 敵の攻撃
        enemy.attack(player);
        
        if (player.health <= 0) {
          break;
        }
        
        writeln();
      }
      
      // アイテム収集チャンス
      if (player.isActive && items.length > 0) {
        auto nearbyItems = items.filter!(item => 
          player.distanceTo(item) < 20.0 && item.isActive
        );
        
        foreach (item; nearbyItems) {
          item.collect(player);
        }
      }
    }
  }
  
  void displayFinalResults() {
    writeln("\n" ~ "=" ~ "=".repeat(59));
    writeln("  最終結果");
    writeln("=" ~ "=".repeat(59) ~ "\n");
    
    if (player.health > 0) {
      writeln("🎉 ゲームクリア！");
    } else {
      writeln("💀 ゲームオーバー");
    }
    
    writefln("\n最終スコア: %d", player.score);
    writefln("残りHP: %d/%d", player.health, player.maxHealth);
    
    int defeatedEnemies = cast(int)enemies.count!(e => !e.isActive);
    writefln("倒した敵: %d/%d", defeatedEnemies, enemies.length);
    
    writeln("\n" ~ "=" ~ "=".repeat(59));
  }
}

// メイン関数
void main() {
  auto game = new GameManager();
  
  // ゲーム初期化
  game.initialize();
  
  // 初期状態を表示
  game.displayStatus();
  
  // ゲームを更新
  game.update(1.0);
  
  // バトルシミュレーション
  game.simulateBattle();
  
  // 最終結果を表示
  game.displayFinalResults();
  
  writeln("\n✓ ゲーム終了");
}

