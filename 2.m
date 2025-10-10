// Objective-C Example - タスク管理アプリ
#import <Foundation/Foundation.h>

// タスククラスのインターフェース
@interface Task : NSObject

@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) BOOL isCompleted;
@property (nonatomic, strong) NSDate *createdAt;

- (instancetype)initWithId:(NSInteger)taskId
                     title:(NSString *)title
               description:(NSString *)description;
- (void)complete;
- (void)displayInfo;

@end

// タスククラスの実装
@implementation Task

- (instancetype)initWithId:(NSInteger)taskId
                     title:(NSString *)title
               description:(NSString *)description {
    self = [super init];
    if (self) {
        _taskId = taskId;
        _title = title;
        _description = description;
        _isCompleted = NO;
        _createdAt = [NSDate date];
    }
    return self;
}

- (void)complete {
    if (!self.isCompleted) {
        self.isCompleted = YES;
        NSLog(@"✓ タスク「%@」を完了しました", self.title);
    } else {
        NSLog(@"✗ このタスクは既に完了しています");
    }
}

- (void)displayInfo {
    NSString *status = self.isCompleted ? @"完了" : @"未完了";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:self.createdAt];
    
    NSLog(@"[%ld] %@ (%@)", (long)self.taskId, self.title, status);
    NSLog(@"    説明: %@", self.description);
    NSLog(@"    作成日時: %@", dateString);
    NSLog(@" ");
}

@end

// タスクマネージャーのインターフェース
@interface TaskManager : NSObject

@property (nonatomic, strong) NSMutableArray<Task *> *tasks;
@property (nonatomic, assign) NSInteger nextTaskId;

- (void)addTaskWithTitle:(NSString *)title description:(NSString *)description;
- (void)completeTaskWithId:(NSInteger)taskId;
- (void)displayAllTasks;
- (void)displayStatistics;
- (NSArray<Task *> *)getIncompleteTasks;

@end

// タスクマネージャーの実装
@implementation TaskManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _tasks = [NSMutableArray array];
        _nextTaskId = 1;
    }
    return self;
}

- (void)addTaskWithTitle:(NSString *)title description:(NSString *)description {
    Task *task = [[Task alloc] initWithId:self.nextTaskId
                                    title:title
                              description:description];
    [self.tasks addObject:task];
    self.nextTaskId++;
    
    NSLog(@"✓ タスクを追加しました: %@", title);
}

- (void)completeTaskWithId:(NSInteger)taskId {
    for (Task *task in self.tasks) {
        if (task.taskId == taskId) {
            [task complete];
            return;
        }
    }
    NSLog(@"✗ タスクが見つかりません (ID: %ld)", (long)taskId);
}

- (void)displayAllTasks {
    NSLog(@"\n=== 全タスク一覧 ===");
    
    if ([self.tasks count] == 0) {
        NSLog(@"タスクがありません");
    } else {
        for (Task *task in self.tasks) {
            [task displayInfo];
        }
    }
}

- (void)displayStatistics {
    NSInteger totalTasks = [self.tasks count];
    NSInteger completedTasks = 0;
    NSInteger incompleteTasks = 0;
    
    for (Task *task in self.tasks) {
        if (task.isCompleted) {
            completedTasks++;
        } else {
            incompleteTasks++;
        }
    }
    
    NSLog(@"\n=== 統計情報 ===");
    NSLog(@"総タスク数: %ld", (long)totalTasks);
    NSLog(@"完了: %ld", (long)completedTasks);
    NSLog(@"未完了: %ld", (long)incompleteTasks);
    
    if (totalTasks > 0) {
        CGFloat completionRate = (CGFloat)completedTasks / totalTasks * 100;
        NSLog(@"完了率: %.1f%%", completionRate);
    }
    
    NSLog(@" ");
}

- (NSArray<Task *> *)getIncompleteTasks {
    NSMutableArray<Task *> *incompleteTasks = [NSMutableArray array];
    
    for (Task *task in self.tasks) {
        if (!task.isCompleted) {
            [incompleteTasks addObject:task];
        }
    }
    
    return [incompleteTasks copy];
}

@end

// メイン関数
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"╔════════════════════════════════╗");
        NSLog(@"║   タスク管理アプリ v1.0       ║");
        NSLog(@"╚════════════════════════════════╝\n");
        
        // タスクマネージャーの初期化
        TaskManager *manager = [[TaskManager alloc] init];
        
        // タスクの追加
        NSLog(@"--- タスクの追加 ---");
        [manager addTaskWithTitle:@"プロジェクト企画書作成"
                      description:@"新規プロジェクトの企画書をまとめる"];
        [manager addTaskWithTitle:@"コードレビュー"
                      description:@"プルリクエストのレビューを行う"];
        [manager addTaskWithTitle:@"会議資料準備"
                      description:@"明日の定例会議の資料を準備"];
        [manager addTaskWithTitle:@"バグ修正"
                      description:@"issue #123の修正対応"];
        [manager addTaskWithTitle:@"ドキュメント更新"
                      description:@"APIドキュメントを最新化"];
        NSLog(@" ");
        
        // 全タスク表示
        [manager displayAllTasks];
        
        // タスクの完了
        NSLog(@"--- タスクの完了 ---");
        [manager completeTaskWithId:1];
        [manager completeTaskWithId:3];
        [manager completeTaskWithId:5];
        [manager completeTaskWithId:1];  // 既に完了済み
        NSLog(@" ");
        
        // 統計情報
        [manager displayStatistics];
        
        // 未完了タスクの表示
        NSLog(@"=== 未完了タスク ===");
        NSArray<Task *> *incompleteTasks = [manager getIncompleteTasks];
        
        if ([incompleteTasks count] == 0) {
            NSLog(@"すべてのタスクが完了しました！");
        } else {
            for (Task *task in incompleteTasks) {
                NSLog(@"• %@", task.title);
            }
        }
        NSLog(@" ");
        
        NSLog(@"✓ プログラム終了");
    }
    return 0;
}

