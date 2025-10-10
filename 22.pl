#!/usr/bin/perl
# Perl Example - ログ解析ツール
use strict;
use warnings;
use feature 'say';

# ログエントリクラス（ハッシュリファレンス）
sub new_log_entry {
  my ($timestamp, $level, $message, $source) = @_;
  
  return {
    timestamp => $timestamp,
    level => $level,
    message => $message,
    source => $source || 'unknown'
  };
}

# ログアナライザーパッケージ
package LogAnalyzer;
use strict;
use warnings;

sub new {
  my ($class) = @_;
  
  my $self = {
    log_entries => [],
    stats => {
      total => 0,
      errors => 0,
      warnings => 0,
      info => 0
    }
  };
  
  return bless $self, $class;
}

sub add_entry {
  my ($self, $entry) = @_;
  
  push @{$self->{log_entries}}, $entry;
  $self->{stats}->{total}++;
  
  # レベル別カウント
  my $level = lc($entry->{level});
  if ($level eq 'error') {
    $self->{stats}->{errors}++;
  } elsif ($level eq 'warning' || $level eq 'warn') {
    $self->{stats}->{warnings}++;
  } elsif ($level eq 'info') {
    $self->{stats}->{info}++;
  }
}

sub parse_log_line {
  my ($self, $line) = @_;
  
  # ログフォーマット: [TIMESTAMP] LEVEL: MESSAGE (SOURCE)
  if ($line =~ /\[(.+?)\]\s+(\w+):\s+(.+?)(?:\s+\((.+?)\))?$/) {
    my ($timestamp, $level, $message, $source) = ($1, $2, $3, $4);
    
    my $entry = main::new_log_entry($timestamp, $level, $message, $source);
    $self->add_entry($entry);
    
    return 1;
  }
  
  return 0;
}

sub load_from_file {
  my ($self, $filename) = @_;
  
  unless (-e $filename) {
    warn "ファイルが見つかりません: $filename\n";
    return 0;
  }
  
  open my $fh, '<', $filename or die "ファイルを開けません: $!\n";
  
  my $count = 0;
  while (my $line = <$fh>) {
    chomp $line;
    next if $line =~ /^\s*$/;  # 空行をスキップ
    
    if ($self->parse_log_line($line)) {
      $count++;
    }
  }
  
  close $fh;
  
  say "✓ $count 件のログエントリを読み込みました";
  return $count;
}

sub get_errors {
  my ($self) = @_;
  
  return grep { lc($_->{level}) eq 'error' } @{$self->{log_entries}};
}

sub get_warnings {
  my ($self) = @_;
  
  return grep { 
    my $level = lc($_->{level});
    $level eq 'warning' || $level eq 'warn'
  } @{$self->{log_entries}};
}

sub get_by_source {
  my ($self, $source) = @_;
  
  return grep { $_->{source} eq $source } @{$self->{log_entries}};
}

sub display_entry {
  my ($self, $entry) = @_;
  
  my $icon = '📝';
  my $level = lc($entry->{level});
  
  if ($level eq 'error') {
    $icon = '❌';
  } elsif ($level eq 'warning' || $level eq 'warn') {
    $icon = '⚠️';
  } elsif ($level eq 'info') {
    $icon = 'ℹ️';
  }
  
  say "$icon [$entry->{timestamp}] $entry->{level}: $entry->{message}";
  say "   ソース: $entry->{source}" if $entry->{source} ne 'unknown';
}

sub display_all_entries {
  my ($self) = @_;
  
  say "\n" . "=" x 60;
  say "  ログエントリ一覧";
  say "=" x 60 . "\n";
  
  if (@{$self->{log_entries}} == 0) {
    say "ログエントリがありません";
    return;
  }
  
  foreach my $entry (@{$self->{log_entries}}) {
    $self->display_entry($entry);
    say "";
  }
}

sub display_statistics {
  my ($self) = @_;
  
  my $stats = $self->{stats};
  
  say "\n" . "=" x 60;
  say "  統計情報";
  say "=" x 60;
  say "総ログ数: $stats->{total}";
  say "エラー: $stats->{errors}";
  say "警告: $stats->{warnings}";
  say "情報: $stats->{info}";
  
  if ($stats->{total} > 0) {
    my $error_rate = sprintf("%.1f", ($stats->{errors} / $stats->{total}) * 100);
    my $warning_rate = sprintf("%.1f", ($stats->{warnings} / $stats->{total}) * 100);
    
    say "\nエラー率: $error_rate%";
    say "警告率: $warning_rate%";
  }
  
  say "=" x 60 . "\n";
}

sub generate_report {
  my ($self) = @_;
  
  my $report = "\n" . "=" x 60 . "\n";
  $report .= "  ログ解析レポート\n";
  $report .= "=" x 60 . "\n\n";
  
  $report .= "生成日時: " . localtime() . "\n";
  $report .= "総ログ数: $self->{stats}->{total}\n\n";
  
  # エラーサマリー
  my @errors = $self->get_errors();
  if (@errors > 0) {
    $report .= "=== エラー一覧 ===\n";
    foreach my $error (@errors) {
      $report .= "- [$error->{timestamp}] $error->{message}\n";
    }
    $report .= "\n";
  }
  
  # 警告サマリー
  my @warnings = $self->get_warnings();
  if (@warnings > 0) {
    $report .= "=== 警告一覧 ===\n";
    foreach my $warning (@warnings) {
      $report .= "- [$warning->{timestamp}] $warning->{message}\n";
    }
    $report .= "\n";
  }
  
  $report .= "=" x 60 . "\n";
  
  return $report;
}

package main;

# ヘルパー関数
sub print_header {
  say "=" x 60;
  say "  Perlログ解析ツール";
  say "=" x 60;
  say "";
}

sub create_sample_log {
  my $filename = shift || 'sample.log';
  
  open my $fh, '>', $filename or die "ファイルを作成できません: $!\n";
  
  print $fh "[2024-01-15 10:30:22] INFO: アプリケーション起動 (system)\n";
  print $fh "[2024-01-15 10:30:25] INFO: データベース接続成功 (database)\n";
  print $fh "[2024-01-15 10:31:10] WARNING: メモリ使用量が80%を超えました (system)\n";
  print $fh "[2024-01-15 10:32:45] ERROR: ユーザー認証に失敗しました (auth)\n";
  print $fh "[2024-01-15 10:33:12] INFO: API リクエスト処理完了 (api)\n";
  print $fh "[2024-01-15 10:34:30] ERROR: データベース接続タイムアウト (database)\n";
  print $fh "[2024-01-15 10:35:00] WARNING: ディスク容量が少なくなっています (system)\n";
  print $fh "[2024-01-15 10:36:15] INFO: バックアップ処理開始 (backup)\n";
  print $fh "[2024-01-15 10:40:22] INFO: バックアップ処理完了 (backup)\n";
  print $fh "[2024-01-15 10:41:33] ERROR: ファイル書き込みエラー (filesystem)\n";
  
  close $fh;
  
  say "✓ サンプルログファイルを作成しました: $filename";
}

# メイン処理
sub main {
  print_header();
  
  # サンプルログファイルを作成
  my $log_file = 'sample.log';
  create_sample_log($log_file);
  say "";
  
  # ログアナライザーを初期化
  my $analyzer = LogAnalyzer->new();
  
  # ログファイルを読み込み
  $analyzer->load_from_file($log_file);
  
  # すべてのエントリを表示
  $analyzer->display_all_entries();
  
  # 統計情報を表示
  $analyzer->display_statistics();
  
  # エラーのみ表示
  say "=" x 60;
  say "  エラーログのみ";
  say "=" x 60 . "\n";
  
  my @errors = $analyzer->get_errors();
  if (@errors > 0) {
    foreach my $error (@errors) {
      $analyzer->display_entry($error);
      say "";
    }
  } else {
    say "エラーはありません";
  }
  
  # ソース別フィルタリング
  say "\n" . "=" x 60;
  say "  systemソースのログ";
  say "=" x 60 . "\n";
  
  my @system_logs = $analyzer->get_by_source('system');
  foreach my $log (@system_logs) {
    $analyzer->display_entry($log);
    say "";
  }
  
  # レポート生成
  my $report = $analyzer->generate_report();
  print $report;
  
  # ファイルにレポートを保存
  open my $report_fh, '>', 'log_report.txt' or warn "レポートファイルを作成できません: $!\n";
  if ($report_fh) {
    print $report_fh $report;
    close $report_fh;
    say "✓ レポートを保存しました: log_report.txt\n";
  }
  
  say "=" x 60;
  say "✓ ログ解析が完了しました";
  say "=" x 60;
}

# プログラム実行
main() unless caller;

1;  # モジュールとして使える

