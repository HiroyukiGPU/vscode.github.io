// Rust Example - ファイル管理システム
use std::fs;
use std::io::{self, Write};
use std::path::{Path, PathBuf};

#[derive(Debug, Clone)]
struct FileInfo {
  path: PathBuf,
  name: String,
  size: u64,
  is_directory: bool,
}

impl FileInfo {
  fn new(path: PathBuf) -> io::Result<Self> {
    let metadata = fs::metadata(&path)?;
    let name = path
      .file_name()
      .and_then(|n| n.to_str())
      .unwrap_or("Unknown")
      .to_string();
    
    Ok(FileInfo {
      path,
      name,
      size: metadata.len(),
      is_directory: metadata.is_dir(),
    })
  }
  
  fn format_size(&self) -> String {
    const UNITS: &[&str] = &["B", "KB", "MB", "GB", "TB"];
    let mut size = self.size as f64;
    let mut unit_index = 0;
    
    while size >= 1024.0 && unit_index < UNITS.len() - 1 {
      size /= 1024.0;
      unit_index += 1;
    }
    
    format!("{:.2} {}", size, UNITS[unit_index])
  }
  
  fn display(&self) {
    let file_type = if self.is_directory { "[DIR] " } else { "[FILE]" };
    println!("{} {} ({})", file_type, self.name, self.format_size());
  }
}

struct FileManager {
  current_path: PathBuf,
  files: Vec<FileInfo>,
}

impl FileManager {
  fn new<P: AsRef<Path>>(path: P) -> io::Result<Self> {
    let current_path = path.as_ref().to_path_buf();
    let mut manager = FileManager {
      current_path,
      files: Vec::new(),
    };
    manager.scan_directory()?;
    Ok(manager)
  }
  
  fn scan_directory(&mut self) -> io::Result<()> {
    self.files.clear();
    
    let entries = fs::read_dir(&self.current_path)?;
    
    for entry in entries {
      let entry = entry?;
      let path = entry.path();
      
      match FileInfo::new(path) {
        Ok(file_info) => self.files.push(file_info),
        Err(e) => eprintln!("Error reading file: {}", e),
      }
    }
    
    // ディレクトリを先に、ファイルを後に並べ替え
    self.files.sort_by(|a, b| {
      match (a.is_directory, b.is_directory) {
        (true, false) => std::cmp::Ordering::Less,
        (false, true) => std::cmp::Ordering::Greater,
        _ => a.name.cmp(&b.name),
      }
    });
    
    println!("✓ Scanned {} items in {:?}", self.files.len(), self.current_path);
    Ok(())
  }
  
  fn list_files(&self) {
    println!("\n=== File List ===");
    println!("Current Directory: {:?}\n", self.current_path);
    
    if self.files.is_empty() {
      println!("(Empty directory)");
      return;
    }
    
    for file in &self.files {
      file.display();
    }
    
    println!("\nTotal: {} items", self.files.len());
    println!("==================\n");
  }
  
  fn get_total_size(&self) -> u64 {
    self.files.iter().filter(|f| !f.is_directory).map(|f| f.size).sum()
  }
  
  fn count_by_type(&self) -> (usize, usize) {
    let directories = self.files.iter().filter(|f| f.is_directory).count();
    let files = self.files.len() - directories;
    (directories, files)
  }
  
  fn search_files(&self, query: &str) -> Vec<&FileInfo> {
    self.files
      .iter()
      .filter(|f| f.name.to_lowercase().contains(&query.to_lowercase()))
      .collect()
  }
  
  fn get_largest_files(&self, count: usize) -> Vec<&FileInfo> {
    let mut files: Vec<&FileInfo> = self.files.iter().filter(|f| !f.is_directory).collect();
    files.sort_by(|a, b| b.size.cmp(&a.size));
    files.into_iter().take(count).collect()
  }
  
  fn display_statistics(&self) {
    let (dirs, files) = self.count_by_type();
    let total_size = self.get_total_size();
    
    println!("\n=== Statistics ===");
    println!("Directories: {}", dirs);
    println!("Files: {}", files);
    println!("Total Size: {:.2} MB", total_size as f64 / 1024.0 / 1024.0);
    println!("==================\n");
  }
}

fn print_header() {
  println!("╔══════════════════════════════════════╗");
  println!("║     File Management System          ║");
  println!("║           Rust Edition              ║");
  println!("╚══════════════════════════════════════╝");
  println!();
}

fn print_section(title: &str) {
  println!("\n{}", "=".repeat(40));
  println!("  {}", title);
  println!("{}", "=".repeat(40));
}

fn main() -> io::Result<()> {
  print_header();
  
  // 現在のディレクトリを取得
  let current_dir = std::env::current_dir()?;
  println!("Working Directory: {:?}\n", current_dir);
  
  // ファイルマネージャーを初期化
  let mut manager = FileManager::new(&current_dir)?;
  
  // ファイル一覧を表示
  print_section("File List");
  manager.list_files();
  
  // 統計情報を表示
  print_section("Statistics");
  manager.display_statistics();
  
  // 最大ファイルを表示
  print_section("Top 5 Largest Files");
  let largest = manager.get_largest_files(5);
  for (index, file) in largest.iter().enumerate() {
    println!("{}. {} - {}", index + 1, file.name, file.format_size());
  }
  
  // ファイル検索のデモ
  print_section("Search Demo");
  let search_query = "main";
  println!("Searching for: '{}'", search_query);
  let results = manager.search_files(search_query);
  
  if results.is_empty() {
    println!("No files found.");
  } else {
    println!("Found {} file(s):", results.len());
    for file in results {
      println!("  - {}", file.name);
    }
  }
  
  println!("\n{}", "=".repeat(40));
  println!("✓ File management operations completed");
  println!("{}\n", "=".repeat(40));
  
  Ok(())
}

#[cfg(test)]
mod tests {
  use super::*;
  
  #[test]
  fn test_format_size() {
    let file = FileInfo {
      path: PathBuf::from("/test"),
      name: "test.txt".to_string(),
      size: 1024,
      is_directory: false,
    };
    
    assert_eq!(file.format_size(), "1.00 KB");
  }
  
  #[test]
  fn test_file_info_creation() {
    let result = FileInfo::new(PathBuf::from("."));
    assert!(result.is_ok());
  }
}

