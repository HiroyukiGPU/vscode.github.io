<?php
// PHP Example - ブログシステム

namespace BlogSystem;

use DateTime;

/**
 * 記事クラス
 */
class Post {
  private int $id;
  private string $title;
  private string $content;
  private string $author;
  private DateTime $createdAt;
  private array $tags;
  private int $views;
  
  public function __construct(int $id, string $title, string $content, string $author) {
    $this->id = $id;
    $this->title = $title;
    $this->content = $content;
    $this->author = $author;
    $this->createdAt = new DateTime();
    $this->tags = [];
    $this->views = 0;
  }
  
  public function addTag(string $tag): void {
    if (!in_array($tag, $this->tags)) {
      $this->tags[] = $tag;
    }
  }
  
  public function incrementViews(): void {
    $this->views++;
  }
  
  public function getExcerpt(int $length = 100): string {
    if (mb_strlen($this->content) <= $length) {
      return $this->content;
    }
    return mb_substr($this->content, 0, $length) . '...';
  }
  
  public function toArray(): array {
    return [
      'id' => $this->id,
      'title' => $this->title,
      'content' => $this->content,
      'author' => $this->author,
      'created_at' => $this->createdAt->format('Y-m-d H:i:s'),
      'tags' => $this->tags,
      'views' => $this->views
    ];
  }
  
  public function display(): void {
    echo "=== {$this->title} ===\n";
    echo "著者: {$this->author} | 投稿日: " . $this->createdAt->format('Y年m月d日') . "\n";
    echo "タグ: " . implode(', ', $this->tags) . " | 閲覧数: {$this->views}\n";
    echo "\n{$this->content}\n";
    echo str_repeat('=', 50) . "\n\n";
  }
  
  // Getters
  public function getId(): int { return $this->id; }
  public function getTitle(): string { return $this->title; }
  public function getTags(): array { return $this->tags; }
}

/**
 * ブログ管理クラス
 */
class Blog {
  private array $posts = [];
  private int $nextId = 1;
  
  public function createPost(string $title, string $content, string $author): Post {
    $post = new Post($this->nextId++, $title, $content, $author);
    $this->posts[] = $post;
    
    echo "新しい記事を投稿しました: {$title}\n";
    return $post;
  }
  
  public function getPostById(int $id): ?Post {
    foreach ($this->posts as $post) {
      if ($post->getId() === $id) {
        return $post;
      }
    }
    return null;
  }
  
  public function getAllPosts(): array {
    return $this->posts;
  }
  
  public function searchByTag(string $tag): array {
    return array_filter($this->posts, function($post) use ($tag) {
      return in_array($tag, $post->getTags());
    });
  }
  
  public function getMostPopular(int $limit = 5): array {
    $sorted = $this->posts;
    usort($sorted, function($a, $b) {
      return $b->toArray()['views'] - $a->toArray()['views'];
    });
    return array_slice($sorted, 0, $limit);
  }
  
  public function displayAllPosts(): void {
    if (empty($this->posts)) {
      echo "記事がありません\n";
      return;
    }
    
    echo "\n=== 全記事一覧 ===\n\n";
    foreach ($this->posts as $post) {
      $post->display();
    }
  }
}

/**
 * ユーティリティ関数
 */
function sanitize(string $input): string {
  return htmlspecialchars($input, ENT_QUOTES, 'UTF-8');
}

function formatDate(DateTime $date): string {
  return $date->format('Y年m月d日 H:i');
}

// メイン処理
echo "=== ブログシステム ===\n\n";

$blog = new Blog();

// 記事を作成
$post1 = $blog->createPost(
  'PHPの基礎',
  'PHPは動的型付けのサーバーサイドスクリプト言語です。Webアプリケーション開発に広く使われています。',
  '山田太郎'
);
$post1->addTag('PHP');
$post1->addTag('プログラミング');
$post1->addTag('初心者');

$post2 = $blog->createPost(
  'データベース設計のコツ',
  'データベース設計では正規化が重要です。適切な正規化により、データの整合性を保ちながら効率的なクエリが可能になります。',
  '佐藤花子'
);
$post2->addTag('データベース');
$post2->addTag('SQL');
$post2->addTag('設計');

$post3 = $blog->createPost(
  'Webセキュリティ入門',
  'Webアプリケーションのセキュリティは非常に重要です。SQLインジェクションやXSSなどの攻撃から守る必要があります。',
  '鈴木一郎'
);
$post3->addTag('セキュリティ');
$post3->addTag('Web');
$post3->addTag('PHP');

// 閲覧数を増やす
$post1->incrementViews();
$post1->incrementViews();
$post1->incrementViews();
$post2->incrementViews();
$post3->incrementViews();
$post3->incrementViews();

// 全記事を表示
$blog->displayAllPosts();

// タグで検索
echo "=== PHPタグの記事 ===\n\n";
$phpPosts = $blog->searchByTag('PHP');
foreach ($phpPosts as $post) {
  echo "- " . $post->getTitle() . "\n";
}
echo "\n";

// 人気記事
echo "=== 人気記事TOP3 ===\n\n";
$popular = $blog->getMostPopular(3);
foreach ($popular as $index => $post) {
  $views = $post->toArray()['views'];
  echo ($index + 1) . ". " . $post->getTitle() . " ({$views} views)\n";
}

?>

