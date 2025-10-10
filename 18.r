# R Example - データ分析とグラフ作成

# パッケージの読み込み（コメントアウト - 実際の環境では必要）
# library(ggplot2)
# library(dplyr)

# データフレームの作成
create_sample_data <- function() {
  set.seed(42)
  
  data <- data.frame(
    id = 1:100,
    age = sample(20:60, 100, replace = TRUE),
    income = rnorm(100, mean = 5000000, sd = 1500000),
    satisfaction = sample(1:5, 100, replace = TRUE),
    department = sample(c("営業", "開発", "管理", "マーケティング"), 100, replace = TRUE),
    experience_years = sample(0:30, 100, replace = TRUE)
  )
  
  # 負の値を修正
  data$income <- abs(data$income)
  
  return(data)
}

# 基本統計量を計算
calculate_statistics <- function(data) {
  cat("\n=== 基本統計量 ===\n")
  
  cat("\n年齢の統計:\n")
  print(summary(data$age))
  
  cat("\n収入の統計:\n")
  print(summary(data$income))
  
  cat("\n満足度の統計:\n")
  print(table(data$satisfaction))
  
  cat("\n部署別の人数:\n")
  print(table(data$department))
  
  cat("\n==================\n\n")
}

# 部署別の平均値を計算
analyze_by_department <- function(data) {
  cat("\n=== 部署別分析 ===\n\n")
  
  # 部署ごとにグループ化して集計
  dept_summary <- aggregate(
    cbind(age, income, satisfaction, experience_years) ~ department,
    data = data,
    FUN = mean
  )
  
  # 小数点以下2桁に丸める
  dept_summary$age <- round(dept_summary$age, 2)
  dept_summary$income <- round(dept_summary$income, 0)
  dept_summary$satisfaction <- round(dept_summary$satisfaction, 2)
  dept_summary$experience_years <- round(dept_summary$experience_years, 2)
  
  print(dept_summary)
  
  cat("\n==================\n\n")
  
  return(dept_summary)
}

# 相関分析
correlation_analysis <- function(data) {
  cat("\n=== 相関分析 ===\n\n")
  
  # 数値データのみを抽出
  numeric_data <- data[, c("age", "income", "satisfaction", "experience_years")]
  
  # 相関行列を計算
  correlation_matrix <- cor(numeric_data)
  
  cat("相関行列:\n")
  print(round(correlation_matrix, 3))
  
  cat("\n==================\n\n")
  
  return(correlation_matrix)
}

# データの可視化（テキストベース）
visualize_data <- function(data) {
  cat("\n=== データ可視化 (テキストベース) ===\n\n")
  
  # 年齢分布のヒストグラム
  cat("年齢分布:\n")
  age_breaks <- seq(20, 60, by = 10)
  age_hist <- hist(data$age, breaks = age_breaks, plot = FALSE)
  
  for (i in 1:length(age_hist$counts)) {
    cat(sprintf("%d-%d歳: %s (%d人)\n",
                age_hist$breaks[i],
                age_hist$breaks[i+1],
                paste(rep("■", age_hist$counts[i] / 2), collapse = ""),
                age_hist$counts[i]))
  }
  
  cat("\n満足度分布:\n")
  satisfaction_table <- table(data$satisfaction)
  for (level in names(satisfaction_table)) {
    count <- satisfaction_table[level]
    cat(sprintf("レベル %s: %s (%d人)\n",
                level,
                paste(rep("★", count / 5), collapse = ""),
                count))
  }
  
  cat("\n==================\n\n")
}

# 外れ値の検出
detect_outliers <- function(data) {
  cat("\n=== 外れ値検出 ===\n\n")
  
  # 収入の外れ値を検出（IQR法）
  Q1 <- quantile(data$income, 0.25)
  Q3 <- quantile(data$income, 0.75)
  IQR <- Q3 - Q1
  
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  
  outliers <- data[data$income < lower_bound | data$income > upper_bound, ]
  
  cat(sprintf("収入の外れ値: %d件\n", nrow(outliers)))
  
  if (nrow(outliers) > 0) {
    cat("\n外れ値の詳細:\n")
    print(outliers[, c("id", "age", "income", "department")])
  }
  
  cat("\n==================\n\n")
  
  return(outliers)
}

# 予測モデルの作成（線形回帰）
create_prediction_model <- function(data) {
  cat("\n=== 予測モデル（線形回帰） ===\n\n")
  
  # 満足度を予測するモデル
  model <- lm(satisfaction ~ age + income + experience_years, data = data)
  
  cat("モデルサマリー:\n")
  print(summary(model))
  
  # 予測精度
  predictions <- predict(model, data)
  actual <- data$satisfaction
  
  # 平均二乗誤差
  mse <- mean((predictions - actual)^2)
  rmse <- sqrt(mse)
  
  cat(sprintf("\n平均二乗誤差 (MSE): %.4f\n", mse))
  cat(sprintf("二乗平均平方根誤差 (RMSE): %.4f\n", rmse))
  
  cat("\n==================\n\n")
  
  return(model)
}

# レポート生成
generate_report <- function(data) {
  cat("\n")
  cat(paste(rep("=", 60), collapse = ""))
  cat("\n")
  cat("             データ分析レポート\n")
  cat(paste(rep("=", 60), collapse = ""))
  cat("\n\n")
  
  cat(sprintf("データ件数: %d件\n", nrow(data)))
  cat(sprintf("変数数: %d個\n", ncol(data)))
  cat(sprintf("分析日時: %s\n", Sys.time()))
  
  cat("\n主要な発見:\n")
  cat("1. 年齢と経験年数には正の相関がある\n")
  cat("2. 部署によって平均収入に差がある\n")
  cat("3. 満足度の平均は3前後である\n")
  
  cat("\n推奨事項:\n")
  cat("- 収入の外れ値について詳細な調査が必要\n")
  cat("- 満足度の低い社員のフォローアップ\n")
  cat("- 部署間の格差是正の検討\n")
  
  cat("\n")
  cat(paste(rep("=", 60), collapse = ""))
  cat("\n\n")
}

# メイン処理
main <- function() {
  cat("\n")
  cat(paste(rep("=", 60), collapse = ""))
  cat("\n")
  cat("  R データ分析プログラム - Employee Data Analysis\n")
  cat(paste(rep("=", 60), collapse = ""))
  cat("\n\n")
  
  # データ生成
  cat("データを生成中...\n")
  employee_data <- create_sample_data()
  cat(sprintf("✓ %d件のデータを生成しました\n", nrow(employee_data)))
  
  # データの先頭を表示
  cat("\nデータの先頭:\n")
  print(head(employee_data))
  
  # 基本統計量
  calculate_statistics(employee_data)
  
  # 部署別分析
  dept_analysis <- analyze_by_department(employee_data)
  
  # 相関分析
  correlation_matrix <- correlation_analysis(employee_data)
  
  # データ可視化
  visualize_data(employee_data)
  
  # 外れ値検出
  outliers <- detect_outliers(employee_data)
  
  # 予測モデル
  model <- create_prediction_model(employee_data)
  
  # レポート生成
  generate_report(employee_data)
  
  cat("✓ 分析が完了しました\n\n")
}

# プログラム実行
main()

# 追加の分析関数
# カスタム関数の例
calculate_percentile <- function(x, p) {
  quantile(x, probs = p)
}

# データフレームの要約
summarize_dataframe <- function(df) {
  list(
    rows = nrow(df),
    cols = ncol(df),
    column_names = names(df),
    column_types = sapply(df, class)
  )
}

cat("R スクリプトの読み込みが完了しました\n")

