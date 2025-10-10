// Swift Example - iOSアプリ（音楽プレイヤー）
import Foundation

// 楽曲構造体
struct Song {
  let id: Int
  let title: String
  let artist: String
  let album: String
  let duration: TimeInterval
  let genre: String
  var playCount: Int = 0
  
  func display() {
    let minutes = Int(duration / 60)
    let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
    
    print("🎵 \(title)")
    print("   アーティスト: \(artist)")
    print("   アルバム: \(album)")
    print("   再生時間: \(minutes):\(String(format: "%02d", seconds))")
    print("   ジャンル: \(genre)")
    print("   再生回数: \(playCount)回")
    print("")
  }
  
  func formatDuration() -> String {
    let minutes = Int(duration / 60)
    let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
    return "\(minutes):\(String(format: "%02d", seconds))"
  }
}

// プレイリスト構造体
struct Playlist {
  let id: Int
  var name: String
  var songs: [Song]
  let createdAt: Date
  
  mutating func addSong(_ song: Song) {
    songs.append(song)
    print("✓ '\(song.title)' をプレイリスト '\(name)' に追加しました")
  }
  
  mutating func removeSong(at index: Int) {
    guard index < songs.count else {
      print("✗ 無効なインデックスです")
      return
    }
    let removed = songs.remove(at: index)
    print("✓ '\(removed.title)' をプレイリストから削除しました")
  }
  
  func getTotalDuration() -> TimeInterval {
    return songs.reduce(0) { $0 + $1.duration }
  }
  
  func display() {
    print("\n📋 プレイリスト: \(name)")
    print("   楽曲数: \(songs.count)曲")
    
    let totalMinutes = Int(getTotalDuration() / 60)
    print("   合計時間: \(totalMinutes)分")
    print("   作成日: \(formatDate(createdAt))")
    print("")
    
    for (index, song) in songs.enumerated() {
      print("  \(index + 1). \(song.title) - \(song.artist) [\(song.formatDuration())]")
    }
    print("")
  }
  
  private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    return formatter.string(from: date)
  }
}

// 音楽プレイヤークラス
class MusicPlayer {
  var currentSong: Song?
  var isPlaying: Bool = false
  var volume: Int = 50
  var playlists: [Playlist] = []
  var library: [Song] = []
  private var nextPlaylistId: Int = 1
  
  init() {
    print("🎼 Music Player initialized")
  }
  
  func addToLibrary(_ song: Song) {
    library.append(song)
    print("✓ '\(song.title)' をライブラリに追加しました")
  }
  
  func createPlaylist(name: String) -> Playlist {
    let playlist = Playlist(
      id: nextPlaylistId,
      name: name,
      songs: [],
      createdAt: Date()
    )
    nextPlaylistId += 1
    playlists.append(playlist)
    print("✓ プレイリスト '\(name)' を作成しました")
    return playlist
  }
  
  func play(_ song: Song) {
    currentSong = song
    isPlaying = true
    print("▶️  再生中: \(song.title) - \(song.artist)")
  }
  
  func pause() {
    guard isPlaying else {
      print("⏸️  既に停止しています")
      return
    }
    isPlaying = false
    print("⏸️  一時停止")
  }
  
  func stop() {
    currentSong = nil
    isPlaying = false
    print("⏹️  停止しました")
  }
  
  func setVolume(_ level: Int) {
    volume = max(0, min(100, level))
    print("🔊 音量: \(volume)%")
  }
  
  func searchSongs(by query: String) -> [Song] {
    return library.filter {
      $0.title.localizedCaseInsensitiveContains(query) ||
      $0.artist.localizedCaseInsensitiveContains(query) ||
      $0.album.localizedCaseInsensitiveContains(query)
    }
  }
  
  func getMostPlayedSongs(limit: Int = 5) -> [Song] {
    return library.sorted { $0.playCount > $1.playCount }
                  .prefix(limit)
                  .map { $0 }
  }
  
  func displayLibrary() {
    print("\n=== 音楽ライブラリ ===")
    print("総楽曲数: \(library.count)曲\n")
    
    for song in library {
      song.display()
    }
    
    print("====================\n")
  }
  
  func displayStatus() {
    print("\n=== プレイヤー状態 ===")
    
    if let song = currentSong {
      print("現在の楽曲: \(song.title)")
      print("アーティスト: \(song.artist)")
      print("状態: \(isPlaying ? "再生中 ▶️" : "一時停止 ⏸️")")
    } else {
      print("再生中の楽曲なし")
    }
    
    print("音量: \(volume)%")
    print("プレイリスト数: \(playlists.count)")
    print("ライブラリ楽曲数: \(library.count)")
    print("====================\n")
  }
}

// メイン処理
func main() {
  print("=" + String(repeating: "=", count: 50))
  print("  🎵 Music Player App - Swift Edition")
  print("=" + String(repeating: "=", count: 50))
  print("")
  
  let player = MusicPlayer()
  
  // 楽曲をライブラリに追加
  let song1 = Song(
    id: 1,
    title: "夏の思い出",
    artist: "山田太郎",
    album: "Summer Memories",
    duration: 245,
    genre: "J-Pop"
  )
  
  let song2 = Song(
    id: 2,
    title: "星空の下で",
    artist: "佐藤花子",
    album: "Night Sky",
    duration: 312,
    genre: "Ballad"
  )
  
  let song3 = Song(
    id: 3,
    title: "エネルギッシュ",
    artist: "鈴木ロック",
    album: "Full Power",
    duration: 198,
    genre: "Rock"
  )
  
  player.addToLibrary(song1)
  player.addToLibrary(song2)
  player.addToLibrary(song3)
  
  // ライブラリを表示
  player.displayLibrary()
  
  // プレイリストを作成
  var favoritePlaylist = player.createPlaylist(name: "お気に入り")
  favoritePlaylist.addSong(song1)
  favoritePlaylist.addSong(song3)
  
  favoritePlaylist.display()
  
  // 楽曲を再生
  print("=== 再生テスト ===\n")
  player.play(song1)
  player.setVolume(70)
  
  Thread.sleep(forTimeInterval: 1)
  
  player.pause()
  player.setVolume(50)
  player.play(song2)
  
  // プレイヤー状態を表示
  player.displayStatus()
  
  // 検索
  print("=== 検索: '夏' ===")
  let searchResults = player.searchSongs(by: "夏")
  for song in searchResults {
    print("  - \(song.title) (\(song.artist))")
  }
  
  print("\n" + String(repeating: "=", count: 50))
  print("✓ Music Player Demo Completed")
  print(String(repeating: "=", count: 50))
}

// プログラム実行
main()

