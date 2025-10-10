# Ruby Example - Webスクレイピングとデータ処理
require 'net/http'
require 'json'
require 'date'

# Bookクラス
class Book
  attr_accessor :title, :author, :price, :published_date, :rating
  
  def initialize(title, author, price, published_date = Date.today, rating = 0.0)
    @title = title
    @author = author
    @price = price
    @published_date = published_date
    @rating = rating
  end
  
  def display
    puts "「#{@title}」"
    puts "  著者: #{@author}"
    puts "  価格: ¥#{@price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse}"
    puts "  出版日: #{@published_date.strftime('%Y年%m月%d日')}"
    puts "  評価: #{'★' * @rating.round}#{'☆' * (5 - @rating.round)} (#{@rating})"
    puts
  end
  
  def on_sale?
    @price < 1000
  end
  
  def new_release?
    (Date.today - @published_date).to_i < 30
  end
end

# BookStoreクラス
class BookStore
  def initialize(name)
    @name = name
    @books = []
    @sales = []
  end
  
  def add_book(book)
    @books << book
    puts "✓ 『#{book.title}』を追加しました"
  end
  
  def remove_book(title)
    book = @books.find { |b| b.title == title }
    if book
      @books.delete(book)
      puts "✓ 『#{title}』を削除しました"
    else
      puts "✗ 『#{title}』が見つかりません"
    end
  end
  
  def search_by_author(author)
    @books.select { |book| book.author == author }
  end
  
  def search_by_price_range(min, max)
    @books.select { |book| book.price >= min && book.price <= max }
  end
  
  def get_bestsellers(limit = 5)
    @books.sort_by { |book| -book.rating }.take(limit)
  end
  
  def display_all_books
    if @books.empty?
      puts "書籍がありません"
      return
    end
    
    puts "\n=== #{@name} 書籍一覧 ==="
    puts
    @books.each_with_index do |book, index|
      puts "[#{index + 1}]"
      book.display
    end
    puts "=" * 50
    puts
  end
  
  def calculate_total_value
    @books.sum(&:price)
  end
  
  def get_statistics
    return {} if @books.empty?
    
    {
      total_books: @books.size,
      total_value: calculate_total_value,
      average_price: calculate_total_value / @books.size,
      average_rating: @books.sum(&:rating) / @books.size,
      on_sale_count: @books.count(&:on_sale?),
      new_releases: @books.count(&:new_release?)
    }
  end
  
  def display_statistics
    stats = get_statistics
    return puts "統計情報がありません" if stats.empty?
    
    puts "\n=== 統計情報 ==="
    puts "総書籍数: #{stats[:total_books]}冊"
    puts "総在庫価値: ¥#{stats[:total_value].to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse}"
    puts "平均価格: ¥#{stats[:average_price]}円"
    puts "平均評価: #{'★' * stats[:average_rating].round}"
    puts "セール対象: #{stats[:on_sale_count]}冊"
    puts "新刊: #{stats[:new_releases]}冊"
    puts "=" * 50
    puts
  end
end

# APIからデータを取得するモジュール
module DataFetcher
  def self.fetch_books_from_api(url)
    begin
      uri = URI(url)
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    rescue => e
      puts "エラー: #{e.message}"
      []
    end
  end
end

# メイン処理
def main
  puts "=" * 50
  puts "書店管理システム"
  puts "=" * 50
  puts
  
  store = BookStore.new("技術書専門店")
  
  # 書籍を追加
  store.add_book(Book.new(
    "Rubyプログラミング入門",
    "山田太郎",
    2800,
    Date.new(2024, 1, 15),
    4.5
  ))
  
  store.add_book(Book.new(
    "Webアプリケーション開発",
    "佐藤花子",
    3200,
    Date.new(2024, 2, 20),
    4.8
  ))
  
  store.add_book(Book.new(
    "データベース設計の基礎",
    "鈴木一郎",
    2500,
    Date.new(2023, 12, 10),
    4.2
  ))
  
  store.add_book(Book.new(
    "アルゴリズム入門",
    "高橋美咲",
    3500,
    Date.new(2024, 3, 5),
    4.7
  ))
  
  store.add_book(Book.new(
    "プログラミング練習問題集",
    "田中健太",
    900,
    Date.new(2024, 3, 15),
    3.9
  ))
  
  # すべての書籍を表示
  store.display_all_books
  
  # 統計情報を表示
  store.display_statistics
  
  # ベストセラーを表示
  puts "=== ベストセラー TOP3 ==="
  store.get_bestsellers(3).each_with_index do |book, index|
    puts "#{index + 1}. #{book.title} (評価: #{book.rating})"
  end
  puts
  
  # 著者で検索
  author = "佐藤花子"
  puts "=== #{author}の書籍 ==="
  store.search_by_author(author).each do |book|
    puts "- #{book.title}"
  end
  puts
  
  # 価格帯で検索
  puts "=== 2000円〜3000円の書籍 ==="
  store.search_by_price_range(2000, 3000).each do |book|
    puts "- #{book.title} (¥#{book.price})"
  end
end

# スクリプト実行
main if __FILE__ == $PROGRAM_NAME

