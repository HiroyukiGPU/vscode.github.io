# Python Example - データ分析とWeb API
import requests
from datetime import datetime
import pandas as pd

class DataAnalyzer:
    """データ分析クラス"""
    
    def __init__(self, api_url):
        self.api_url = api_url
        self.data = []
    
    def fetch_data(self):
        """APIからデータを取得"""
        try:
            response = requests.get(self.api_url)
            if response.status_code == 200:
                self.data = response.json()
                print(f"データ取得成功: {len(self.data)}件")
                return True
        except Exception as e:
            print(f"エラー: {e}")
            return False
    
    def analyze(self):
        """データを分析"""
        if not self.data:
            print("データがありません")
            return None
        
        df = pd.DataFrame(self.data)
        
        # 基本統計量を計算
        stats = {
            'count': len(df),
            'mean': df['value'].mean(),
            'median': df['value'].median(),
            'std': df['value'].std()
        }
        
        return stats
    
    def generate_report(self):
        """レポートを生成"""
        stats = self.analyze()
        
        if stats:
            report = f"""
            データ分析レポート
            ==================
            生成日時: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
            データ件数: {stats['count']}
            平均値: {stats['mean']:.2f}
            中央値: {stats['median']:.2f}
            標準偏差: {stats['std']:.2f}
            """
            print(report)

def main():
    # メイン処理
    analyzer = DataAnalyzer('https://api.example.com/data')
    
    if analyzer.fetch_data():
        analyzer.generate_report()
    else:
        print("データの取得に失敗しました")

if __name__ == '__main__':
    main()

