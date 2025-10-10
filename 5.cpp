// C++ Example - ゲーム開発（RPGシステム）
#include <iostream>
#include <vector>
#include <string>
#include <memory>
#include <algorithm>
#include <ctime>
#include <cstdlib>

using namespace std;

// キャラクター基底クラス
class Character {
protected:
  string name;
  int health;
  int maxHealth;
  int attack;
  int defense;
  
public:
  Character(const string& name, int health, int attack, int defense)
    : name(name), health(health), maxHealth(health), 
      attack(attack), defense(defense) {}
  
  virtual ~Character() {}
  
  virtual void displayInfo() const {
    cout << name << " [HP: " << health << "/" << maxHealth 
         << " | ATK: " << attack << " | DEF: " << defense << "]" << endl;
  }
  
  bool isAlive() const {
    return health > 0;
  }
  
  void takeDamage(int damage) {
    int actualDamage = max(0, damage - defense);
    health -= actualDamage;
    health = max(0, health);
    
    cout << name << "は " << actualDamage << " のダメージを受けた！" << endl;
    
    if (!isAlive()) {
      cout << name << "は倒れた..." << endl;
    }
  }
  
  void heal(int amount) {
    health = min(maxHealth, health + amount);
    cout << name << "は " << amount << " 回復した！" << endl;
  }
  
  string getName() const { return name; }
  int getAttack() const { return attack; }
  int getHealth() const { return health; }
};

// プレイヤークラス
class Player : public Character {
private:
  int level;
  int experience;
  int maxExperience;
  
public:
  Player(const string& name)
    : Character(name, 100, 20, 10), 
      level(1), experience(0), maxExperience(100) {}
  
  void displayInfo() const override {
    Character::displayInfo();
    cout << "  Level: " << level << " | EXP: " << experience 
         << "/" << maxExperience << endl;
  }
  
  void gainExperience(int exp) {
    experience += exp;
    cout << exp << " の経験値を獲得！" << endl;
    
    if (experience >= maxExperience) {
      levelUp();
    }
  }
  
  void levelUp() {
    level++;
    experience = 0;
    maxExperience += 50;
    
    maxHealth += 20;
    health = maxHealth;
    attack += 5;
    defense += 3;
    
    cout << "\n★ レベルアップ！ Lv." << level << " になった！" << endl;
    displayInfo();
  }
  
  void useSkill(Character* target) {
    int damage = attack * 2;
    cout << name << "は必殺技を使った！" << endl;
    target->takeDamage(damage);
  }
};

// 敵クラス
class Enemy : public Character {
private:
  int expReward;
  
public:
  Enemy(const string& name, int health, int attack, int defense, int exp)
    : Character(name, health, attack, defense), expReward(exp) {}
  
  void performAttack(Character* target) {
    int damage = attack + (rand() % 10);
    cout << name << "の攻撃！" << endl;
    target->takeDamage(damage);
  }
  
  int getExpReward() const { return expReward; }
};

// バトルシステム
class Battle {
private:
  Player* player;
  unique_ptr<Enemy> enemy;
  
public:
  Battle(Player* p, unique_ptr<Enemy> e)
    : player(p), enemy(move(e)) {}
  
  void start() {
    cout << "\n=== バトル開始！ ===" << endl;
    cout << player->getName() << " VS " << enemy->getName() << endl;
    cout << "===================\n" << endl;
    
    while (player->isAlive() && enemy->isAlive()) {
      playerTurn();
      
      if (!enemy->isAlive()) break;
      
      enemyTurn();
    }
    
    if (player->isAlive()) {
      victory();
    } else {
      defeat();
    }
  }
  
private:
  void playerTurn() {
    cout << "\n--- あなたのターン ---" << endl;
    cout << "1. 攻撃  2. 必殺技  3. 回復" << endl;
    cout << "選択: ";
    
    int choice = 1; // デモ用に自動選択
    
    switch (choice) {
      case 1:
        performAttack();
        break;
      case 2:
        player->useSkill(enemy.get());
        break;
      case 3:
        player->heal(30);
        break;
    }
  }
  
  void performAttack() {
    int damage = player->getAttack() + (rand() % 15);
    cout << player->getName() << "の攻撃！" << endl;
    enemy->takeDamage(damage);
  }
  
  void enemyTurn() {
    if (enemy->isAlive()) {
      cout << "\n--- 敵のターン ---" << endl;
      enemy->performAttack(player);
    }
  }
  
  void victory() {
    cout << "\n=== 勝利！ ===" << endl;
    player->gainExperience(enemy->getExpReward());
  }
  
  void defeat() {
    cout << "\n=== 敗北... ===" << endl;
    cout << "GAME OVER" << endl;
  }
};

// メイン関数
int main() {
  srand(time(nullptr));
  
  cout << "=== RPGゲーム ===" << endl;
  cout << "プレイヤー名を入力してください: ";
  
  string playerName = "勇者"; // デモ用
  cout << playerName << endl;
  
  Player player(playerName);
  
  // 敵との戦闘
  vector<unique_ptr<Enemy>> enemies;
  enemies.push_back(make_unique<Enemy>("スライム", 30, 10, 2, 50));
  enemies.push_back(make_unique<Enemy>("ゴブリン", 50, 15, 5, 80));
  enemies.push_back(make_unique<Enemy>("ドラゴン", 100, 25, 10, 150));
  
  for (auto& enemy : enemies) {
    if (!player.isAlive()) break;
    
    Battle battle(&player, move(enemy));
    battle.start();
    
    cout << "\n現在のステータス:" << endl;
    player.displayInfo();
  }
  
  if (player.isAlive()) {
    cout << "\n★ おめでとう！すべての敵を倒しました！★" << endl;
  }
  
  return 0;
}

