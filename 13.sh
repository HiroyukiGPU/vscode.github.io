#!/bin/bash
# Shell Script Example - システム監視とログ管理

# 色の定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログディレクトリ
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/system_monitor.log"

# ログ関数
log_info() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${GREEN}[INFO]${NC} ${timestamp} - ${message}"
  echo "[INFO] ${timestamp} - ${message}" >> "$LOG_FILE"
}

log_warning() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${YELLOW}[WARN]${NC} ${timestamp} - ${message}"
  echo "[WARN] ${timestamp} - ${message}" >> "$LOG_FILE"
}

log_error() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${RED}[ERROR]${NC} ${timestamp} - ${message}"
  echo "[ERROR] ${timestamp} - ${message}" >> "$LOG_FILE"
}

# 初期化
initialize() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}  System Monitor Script${NC}"
  echo -e "${BLUE}========================================${NC}\n"
  
  # ログディレクトリの作成
  if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
    log_info "Log directory created: $LOG_DIR"
  fi
  
  log_info "Script started"
}

# システム情報を取得
get_system_info() {
  echo -e "\n${BLUE}=== System Information ===${NC}"
  
  # OS情報
  if [ "$(uname)" == "Darwin" ]; then
    OS="macOS $(sw_vers -productVersion)"
  elif [ "$(uname)" == "Linux" ]; then
    OS=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f 2)
  else
    OS="$(uname -s)"
  fi
  
  echo "OS: $OS"
  echo "Hostname: $(hostname)"
  echo "Kernel: $(uname -r)"
  echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
  
  log_info "System info retrieved"
}

# CPU使用率をチェック
check_cpu_usage() {
  echo -e "\n${BLUE}=== CPU Usage ===${NC}"
  
  if [ "$(uname)" == "Darwin" ]; then
    # macOSの場合
    CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
  else
    # Linuxの場合
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d '%' -f 1)
  fi
  
  echo "CPU Usage: ${CPU_USAGE}%"
  
  # 閾値チェック
  THRESHOLD=80
  if [ $(echo "$CPU_USAGE > $THRESHOLD" | bc -l) -eq 1 ]; then
    log_warning "High CPU usage detected: ${CPU_USAGE}%"
  else
    log_info "CPU usage is normal: ${CPU_USAGE}%"
  fi
}

# メモリ使用量をチェック
check_memory_usage() {
  echo -e "\n${BLUE}=== Memory Usage ===${NC}"
  
  if [ "$(uname)" == "Darwin" ]; then
    # macOSの場合
    TOTAL_MEM=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')
    FREE_MEM=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//' | awk '{print $1*4096/1024/1024/1024}')
  else
    # Linuxの場合
    TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
    FREE_MEM=$(free -g | awk '/^Mem:/{print $4}')
  fi
  
  USED_MEM=$(echo "$TOTAL_MEM - $FREE_MEM" | bc)
  USAGE_PERCENT=$(echo "scale=2; ($USED_MEM / $TOTAL_MEM) * 100" | bc)
  
  echo "Total Memory: ${TOTAL_MEM} GB"
  echo "Used Memory: ${USED_MEM} GB"
  echo "Free Memory: ${FREE_MEM} GB"
  echo "Usage: ${USAGE_PERCENT}%"
  
  if [ $(echo "$USAGE_PERCENT > 90" | bc -l) -eq 1 ]; then
    log_warning "High memory usage: ${USAGE_PERCENT}%"
  else
    log_info "Memory usage is normal: ${USAGE_PERCENT}%"
  fi
}

# ディスク使用量をチェック
check_disk_usage() {
  echo -e "\n${BLUE}=== Disk Usage ===${NC}"
  
  df -h | grep -v "Filesystem" | while read line; do
    usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    partition=$(echo $line | awk '{print $1}')
    
    if [ "$usage" -gt 80 ]; then
      log_warning "Disk usage high on $partition: ${usage}%"
    fi
  done
  
  df -h
  log_info "Disk usage checked"
}

# プロセス監視
check_processes() {
  echo -e "\n${BLUE}=== Top 10 Processes (by CPU) ===${NC}"
  ps aux | sort -nrk 3,3 | head -n 11 | tail -n 10
  
  log_info "Process list retrieved"
}

# ネットワーク状態をチェック
check_network() {
  echo -e "\n${BLUE}=== Network Status ===${NC}"
  
  # pingテスト
  if ping -c 1 google.com &> /dev/null; then
    echo -e "${GREEN}✓${NC} Internet connection: OK"
    log_info "Internet connection is active"
  else
    echo -e "${RED}✗${NC} Internet connection: Failed"
    log_error "Internet connection is down"
  fi
  
  # アクティブな接続数
  if [ "$(uname)" == "Darwin" ]; then
    CONN_COUNT=$(netstat -an | grep ESTABLISHED | wc -l)
  else
    CONN_COUNT=$(netstat -an | grep ESTABLISHED | wc -l)
  fi
  
  echo "Active connections: $CONN_COUNT"
}

# ログのクリーンアップ
cleanup_logs() {
  local days=${1:-7}
  echo -e "\n${BLUE}=== Log Cleanup ===${NC}"
  
  find "$LOG_DIR" -name "*.log" -type f -mtime +$days -delete
  log_info "Cleaned up logs older than $days days"
}

# レポート生成
generate_report() {
  local report_file="$LOG_DIR/report_$(date '+%Y%m%d_%H%M%S').txt"
  
  echo "System Monitor Report" > "$report_file"
  echo "Generated: $(date)" >> "$report_file"
  echo "======================================" >> "$report_file"
  
  get_system_info >> "$report_file" 2>&1
  check_cpu_usage >> "$report_file" 2>&1
  check_memory_usage >> "$report_file" 2>&1
  check_disk_usage >> "$report_file" 2>&1
  
  echo -e "\n${GREEN}✓${NC} Report generated: $report_file"
  log_info "Report generated: $report_file"
}

# ヘルプメッセージ
show_help() {
  cat << EOF
Usage: $0 [OPTIONS]

Options:
  -h, --help          Show this help message
  -a, --all           Run all checks
  -c, --cpu           Check CPU usage
  -m, --memory        Check memory usage
  -d, --disk          Check disk usage
  -p, --processes     Show top processes
  -n, --network       Check network status
  -r, --report        Generate report
  --cleanup [DAYS]    Clean up old logs (default: 7 days)

Examples:
  $0 --all                  # Run all checks
  $0 --cpu --memory         # Check CPU and memory only
  $0 --cleanup 30           # Remove logs older than 30 days

EOF
}

# メイン処理
main() {
  initialize
  
  if [ $# -eq 0 ]; then
    # 引数がない場合はすべて実行
    get_system_info
    check_cpu_usage
    check_memory_usage
    check_disk_usage
    check_processes
    check_network
  else
    # 引数に応じて実行
    while [[ $# -gt 0 ]]; do
      case $1 in
        -h|--help)
          show_help
          exit 0
          ;;
        -a|--all)
          get_system_info
          check_cpu_usage
          check_memory_usage
          check_disk_usage
          check_processes
          check_network
          ;;
        -c|--cpu)
          check_cpu_usage
          ;;
        -m|--memory)
          check_memory_usage
          ;;
        -d|--disk)
          check_disk_usage
          ;;
        -p|--processes)
          check_processes
          ;;
        -n|--network)
          check_network
          ;;
        -r|--report)
          generate_report
          ;;
        --cleanup)
          shift
          cleanup_logs ${1:-7}
          ;;
        *)
          echo "Unknown option: $1"
          show_help
          exit 1
          ;;
      esac
      shift
    done
  fi
  
  log_info "Script completed"
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${GREEN}✓ Monitoring complete${NC}"
  echo -e "${BLUE}========================================${NC}\n"
}

# スクリプト実行
main "$@"

