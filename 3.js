// JavaScript Example - ToDoアプリケーション
class TodoApp {
  constructor() {
    this.todos = [];
    this.nextId = 1;
    this.filter = 'all';
    
    this.init();
  }
  
  init() {
    console.log('ToDoアプリを初期化中...');
    this.loadFromStorage();
    this.setupEventListeners();
    this.render();
  }
  
  setupEventListeners() {
    const form = document.getElementById('todo-form');
    const filterBtns = document.querySelectorAll('.filter-btn');
    
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        this.addTodo();
      });
    }
    
    filterBtns.forEach(btn => {
      btn.addEventListener('click', (e) => {
        this.setFilter(e.target.dataset.filter);
      });
    });
  }
  
  addTodo() {
    const input = document.getElementById('todo-input');
    const text = input.value.trim();
    
    if (!text) {
      alert('ToDoを入力してください');
      return;
    }
    
    const todo = {
      id: this.nextId++,
      text: text,
      completed: false,
      createdAt: new Date().toISOString()
    };
    
    this.todos.push(todo);
    this.saveToStorage();
    this.render();
    
    input.value = '';
    console.log('新しいToDoを追加しました:', todo);
  }
  
  toggleTodo(id) {
    const todo = this.todos.find(t => t.id === id);
    if (todo) {
      todo.completed = !todo.completed;
      this.saveToStorage();
      this.render();
    }
  }
  
  deleteTodo(id) {
    this.todos = this.todos.filter(t => t.id !== id);
    this.saveToStorage();
    this.render();
  }
  
  setFilter(filter) {
    this.filter = filter;
    this.render();
  }
  
  getFilteredTodos() {
    switch (this.filter) {
      case 'active':
        return this.todos.filter(t => !t.completed);
      case 'completed':
        return this.todos.filter(t => t.completed);
      default:
        return this.todos;
    }
  }
  
  render() {
    const container = document.getElementById('todo-list');
    if (!container) return;
    
    const filteredTodos = this.getFilteredTodos();
    
    if (filteredTodos.length === 0) {
      container.innerHTML = '<p class="empty-message">ToDoがありません</p>';
      return;
    }
    
    container.innerHTML = filteredTodos.map(todo => `
      <div class="todo-item ${todo.completed ? 'completed' : ''}">
        <input 
          type="checkbox" 
          ${todo.completed ? 'checked' : ''}
          onchange="app.toggleTodo(${todo.id})"
        >
        <span class="todo-text">${this.escapeHtml(todo.text)}</span>
        <button onclick="app.deleteTodo(${todo.id})">削除</button>
      </div>
    `).join('');
    
    this.updateStats();
  }
  
  updateStats() {
    const total = this.todos.length;
    const completed = this.todos.filter(t => t.completed).length;
    const active = total - completed;
    
    console.log(`統計: 合計${total}件, 完了${completed}件, 未完了${active}件`);
  }
  
  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
  
  saveToStorage() {
    try {
      localStorage.setItem('todos', JSON.stringify(this.todos));
      localStorage.setItem('nextId', this.nextId.toString());
    } catch (error) {
      console.error('保存エラー:', error);
    }
  }
  
  loadFromStorage() {
    try {
      const saved = localStorage.getItem('todos');
      if (saved) {
        this.todos = JSON.parse(saved);
      }
      
      const savedId = localStorage.getItem('nextId');
      if (savedId) {
        this.nextId = parseInt(savedId);
      }
    } catch (error) {
      console.error('読み込みエラー:', error);
    }
  }
}

// アプリケーション起動
document.addEventListener('DOMContentLoaded', () => {
  window.app = new TodoApp();
});

// エクスポート（ES6モジュール用）
export default TodoApp;

