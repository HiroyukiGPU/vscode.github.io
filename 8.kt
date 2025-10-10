// Kotlin Example - モバイルアプリ（タスク管理）
package com.example.taskmanager

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

// データクラス
data class Task(
  val id: Int,
  var title: String,
  var description: String,
  var isCompleted: Boolean = false,
  val createdAt: LocalDateTime = LocalDateTime.now(),
  var priority: Priority = Priority.MEDIUM
)

enum class Priority(val level: Int) {
  LOW(1),
  MEDIUM(2),
  HIGH(3),
  URGENT(4);
  
  fun getDisplayName(): String = when(this) {
    LOW -> "低"
    MEDIUM -> "中"
    HIGH -> "高"
    URGENT -> "緊急"
  }
}

// タスク管理クラス
class TaskManager {
  private val tasks = mutableListOf<Task>()
  private var nextId = 1
  
  fun addTask(title: String, description: String, priority: Priority = Priority.MEDIUM): Task {
    val task = Task(
      id = nextId++,
      title = title,
      description = description,
      priority = priority
    )
    tasks.add(task)
    println("✓ タスクを追加しました: $title")
    return task
  }
  
  fun completeTask(id: Int) {
    val task = tasks.find { it.id == id }
    if (task != null) {
      task.isCompleted = true
      println("✓ タスクを完了しました: ${task.title}")
    } else {
      println("✗ タスクが見つかりません (ID: $id)")
    }
  }
  
  fun deleteTask(id: Int) {
    val removed = tasks.removeIf { it.id == id }
    if (removed) {
      println("✓ タスクを削除しました")
    } else {
      println("✗ タスクが見つかりません")
    }
  }
  
  fun getAllTasks(): List<Task> = tasks.toList()
  
  fun getActiveTasks(): List<Task> = tasks.filter { !it.isCompleted }
  
  fun getCompletedTasks(): List<Task> = tasks.filter { it.isCompleted }
  
  fun getTasksByPriority(priority: Priority): List<Task> = 
    tasks.filter { it.priority == priority }
  
  fun displayTasks() {
    if (tasks.isEmpty()) {
      println("タスクがありません")
      return
    }
    
    println("\n=== タスク一覧 ===")
    val formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm")
    
    tasks.sortedByDescending { it.priority.level }.forEach { task ->
      val status = if (task.isCompleted) "✓" else "○"
      val priorityMark = "⚑".repeat(task.priority.level)
      
      println("[$status] ${task.id}. ${task.title}")
      println("    優先度: $priorityMark ${task.priority.getDisplayName()}")
      println("    説明: ${task.description}")
      println("    作成日時: ${task.createdAt.format(formatter)}")
      println()
    }
    println("==================\n")
  }
  
  fun getStatistics(): TaskStatistics {
    return TaskStatistics(
      total = tasks.size,
      completed = tasks.count { it.isCompleted },
      active = tasks.count { !it.isCompleted },
      urgent = tasks.count { it.priority == Priority.URGENT },
      high = tasks.count { it.priority == Priority.HIGH }
    )
  }
}

data class TaskStatistics(
  val total: Int,
  val completed: Int,
  val active: Int,
  val urgent: Int,
  val high: Int
) {
  fun display() {
    println("\n=== 統計情報 ===")
    println("総タスク数: $total")
    println("完了: $completed")
    println("未完了: $active")
    println("緊急: $urgent")
    println("高優先度: $high")
    println("完了率: ${if (total > 0) (completed * 100 / total) else 0}%")
    println("================\n")
  }
}

// 拡張関数
fun String.truncate(maxLength: Int): String {
  return if (this.length <= maxLength) this 
  else "${this.substring(0, maxLength)}..."
}

// メイン関数
fun main() {
  println("=== タスク管理アプリ ===\n")
  
  val manager = TaskManager()
  
  // タスクを追加
  manager.addTask(
    "レポートを作成",
    "月次レポートを作成して提出する",
    Priority.HIGH
  )
  
  manager.addTask(
    "会議の準備",
    "プレゼンテーション資料を用意する",
    Priority.URGENT
  )
  
  manager.addTask(
    "メールの返信",
    "未読メールに返信する",
    Priority.MEDIUM
  )
  
  manager.addTask(
    "コードレビュー",
    "プルリクエストをレビューする",
    Priority.HIGH
  )
  
  manager.addTask(
    "ドキュメント更新",
    "APIドキュメントを最新版に更新する",
    Priority.LOW
  )
  
  // タスク一覧を表示
  manager.displayTasks()
  
  // タスクを完了
  manager.completeTask(1)
  manager.completeTask(3)
  
  // 統計情報を表示
  manager.getStatistics().display()
  
  // 優先度別に表示
  println("=== 緊急タスク ===")
  manager.getTasksByPriority(Priority.URGENT).forEach {
    println("- ${it.title}")
  }
  
  println("\n=== 未完了タスク ===")
  manager.getActiveTasks().forEach {
    println("- ${it.title} [${it.priority.getDisplayName()}]")
  }
}

