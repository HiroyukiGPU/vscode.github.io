// C Example - 学生管理システム
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NAME 50
#define MAX_STUDENTS 100

// 学生構造体
typedef struct {
  int id;
  char name[MAX_NAME];
  int age;
  float gpa;
} Student;

// 学生管理システム構造体
typedef struct {
  Student students[MAX_STUDENTS];
  int count;
} StudentManager;

// 関数プロトタイプ宣言
void init_manager(StudentManager *manager);
int add_student(StudentManager *manager, const char *name, int age, float gpa);
void display_student(const Student *student);
void display_all_students(const StudentManager *manager);
Student* find_student_by_id(StudentManager *manager, int id);
float calculate_average_gpa(const StudentManager *manager);
void sort_students_by_gpa(StudentManager *manager);

// 初期化
void init_manager(StudentManager *manager) {
  manager->count = 0;
  printf("学生管理システムを初期化しました\n");
}

// 学生を追加
int add_student(StudentManager *manager, const char *name, int age, float gpa) {
  if (manager->count >= MAX_STUDENTS) {
    printf("エラー: これ以上学生を追加できません\n");
    return 0;
  }
  
  if (gpa < 0.0 || gpa > 4.0) {
    printf("エラー: GPAは0.0から4.0の範囲で指定してください\n");
    return 0;
  }
  
  Student *student = &manager->students[manager->count];
  student->id = manager->count + 1;
  strncpy(student->name, name, MAX_NAME - 1);
  student->name[MAX_NAME - 1] = '\0';
  student->age = age;
  student->gpa = gpa;
  
  manager->count++;
  printf("学生を追加しました: %s (ID: %d)\n", name, student->id);
  
  return 1;
}

// 学生情報を表示
void display_student(const Student *student) {
  printf("ID: %d | 名前: %s | 年齢: %d | GPA: %.2f\n",
         student->id, student->name, student->age, student->gpa);
}

// すべての学生を表示
void display_all_students(const StudentManager *manager) {
  if (manager->count == 0) {
    printf("登録されている学生はいません\n");
    return;
  }
  
  printf("\n=== 学生一覧 ===\n");
  for (int i = 0; i < manager->count; i++) {
    display_student(&manager->students[i]);
  }
  printf("================\n\n");
}

// IDで学生を検索
Student* find_student_by_id(StudentManager *manager, int id) {
  for (int i = 0; i < manager->count; i++) {
    if (manager->students[i].id == id) {
      return &manager->students[i];
    }
  }
  return NULL;
}

// 平均GPAを計算
float calculate_average_gpa(const StudentManager *manager) {
  if (manager->count == 0) {
    return 0.0;
  }
  
  float total = 0.0;
  for (int i = 0; i < manager->count; i++) {
    total += manager->students[i].gpa;
  }
  
  return total / manager->count;
}

// GPAでソート（降順）
void sort_students_by_gpa(StudentManager *manager) {
  for (int i = 0; i < manager->count - 1; i++) {
    for (int j = 0; j < manager->count - i - 1; j++) {
      if (manager->students[j].gpa < manager->students[j + 1].gpa) {
        Student temp = manager->students[j];
        manager->students[j] = manager->students[j + 1];
        manager->students[j + 1] = temp;
      }
    }
  }
  printf("GPAでソートしました\n");
}

// メイン関数
int main() {
  StudentManager manager;
  init_manager(&manager);
  
  // 学生を追加
  add_student(&manager, "田中太郎", 20, 3.8);
  add_student(&manager, "佐藤花子", 21, 3.9);
  add_student(&manager, "鈴木一郎", 19, 3.5);
  add_student(&manager, "高橋美咲", 22, 3.7);
  
  // すべての学生を表示
  display_all_students(&manager);
  
  // 平均GPAを計算
  float avg_gpa = calculate_average_gpa(&manager);
  printf("平均GPA: %.2f\n\n", avg_gpa);
  
  // GPAでソート
  sort_students_by_gpa(&manager);
  display_all_students(&manager);
  
  // IDで検索
  int search_id = 2;
  Student *found = find_student_by_id(&manager, search_id);
  if (found != NULL) {
    printf("ID %d の学生が見つかりました:\n", search_id);
    display_student(found);
  } else {
    printf("ID %d の学生は見つかりませんでした\n", search_id);
  }
  
  return 0;
}

