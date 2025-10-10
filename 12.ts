// TypeScript Example - チャットアプリケーション
interface User {
  id: number;
  username: string;
  email: string;
  avatar?: string;
  isOnline: boolean;
}

interface Message {
  id: number;
  senderId: number;
  content: string;
  timestamp: Date;
  isRead: boolean;
  type: 'text' | 'image' | 'file';
}

interface ChatRoom {
  id: number;
  name: string;
  participants: number[];
  messages: Message[];
  createdAt: Date;
}

type MessageCallback = (message: Message) => void;

class ChatApplication {
  private users: Map<number, User> = new Map();
  private rooms: Map<number, ChatRoom> = new Map();
  private nextUserId: number = 1;
  private nextRoomId: number = 1;
  private nextMessageId: number = 1;
  private messageCallbacks: MessageCallback[] = [];
  
  constructor() {
    console.log('💬 Chat Application initialized');
  }
  
  // ユーザー管理
  registerUser(username: string, email: string): User {
    const user: User = {
      id: this.nextUserId++,
      username,
      email,
      isOnline: false
    };
    
    this.users.set(user.id, user);
    console.log(`✓ User registered: ${username} (ID: ${user.id})`);
    
    return user;
  }
  
  loginUser(userId: number): boolean {
    const user = this.users.get(userId);
    if (user) {
      user.isOnline = true;
      console.log(`✓ ${user.username} logged in`);
      return true;
    }
    return false;
  }
  
  logoutUser(userId: number): void {
    const user = this.users.get(userId);
    if (user) {
      user.isOnline = false;
      console.log(`✓ ${user.username} logged out`);
    }
  }
  
  getOnlineUsers(): User[] {
    return Array.from(this.users.values()).filter(u => u.isOnline);
  }
  
  // チャットルーム管理
  createRoom(name: string, creatorId: number): ChatRoom | null {
    const user = this.users.get(creatorId);
    if (!user) {
      console.error('User not found');
      return null;
    }
    
    const room: ChatRoom = {
      id: this.nextRoomId++,
      name,
      participants: [creatorId],
      messages: [],
      createdAt: new Date()
    };
    
    this.rooms.set(room.id, room);
    console.log(`✓ Room created: ${name} (ID: ${room.id})`);
    
    return room;
  }
  
  joinRoom(roomId: number, userId: number): boolean {
    const room = this.rooms.get(roomId);
    const user = this.users.get(userId);
    
    if (!room || !user) {
      console.error('Room or user not found');
      return false;
    }
    
    if (!room.participants.includes(userId)) {
      room.participants.push(userId);
      console.log(`✓ ${user.username} joined room: ${room.name}`);
    }
    
    return true;
  }
  
  leaveRoom(roomId: number, userId: number): void {
    const room = this.rooms.get(roomId);
    if (room) {
      room.participants = room.participants.filter(id => id !== userId);
      const user = this.users.get(userId);
      if (user) {
        console.log(`✓ ${user.username} left room: ${room.name}`);
      }
    }
  }
  
  // メッセージ管理
  sendMessage(roomId: number, senderId: number, content: string, type: 'text' | 'image' | 'file' = 'text'): Message | null {
    const room = this.rooms.get(roomId);
    const sender = this.users.get(senderId);
    
    if (!room || !sender) {
      console.error('Room or sender not found');
      return null;
    }
    
    if (!room.participants.includes(senderId)) {
      console.error('User is not in the room');
      return null;
    }
    
    const message: Message = {
      id: this.nextMessageId++,
      senderId,
      content,
      timestamp: new Date(),
      isRead: false,
      type
    };
    
    room.messages.push(message);
    console.log(`📨 ${sender.username}: ${content}`);
    
    // メッセージコールバックを実行
    this.messageCallbacks.forEach(callback => callback(message));
    
    return message;
  }
  
  getRoomMessages(roomId: number, limit?: number): Message[] {
    const room = this.rooms.get(roomId);
    if (!room) return [];
    
    const messages = room.messages;
    return limit ? messages.slice(-limit) : messages;
  }
  
  markAsRead(messageId: number): void {
    for (const room of this.rooms.values()) {
      const message = room.messages.find(m => m.id === messageId);
      if (message) {
        message.isRead = true;
        break;
      }
    }
  }
  
  // イベントリスナー
  onMessage(callback: MessageCallback): void {
    this.messageCallbacks.push(callback);
  }
  
  // 統計情報
  getStatistics(): {
    totalUsers: number;
    onlineUsers: number;
    totalRooms: number;
    totalMessages: number;
  } {
    let totalMessages = 0;
    for (const room of this.rooms.values()) {
      totalMessages += room.messages.length;
    }
    
    return {
      totalUsers: this.users.size,
      onlineUsers: this.getOnlineUsers().length,
      totalRooms: this.rooms.size,
      totalMessages
    };
  }
  
  displayStatistics(): void {
    const stats = this.getStatistics();
    console.log('\n=== Statistics ===');
    console.log(`Total Users: ${stats.totalUsers}`);
    console.log(`Online Users: ${stats.onlineUsers}`);
    console.log(`Total Rooms: ${stats.totalRooms}`);
    console.log(`Total Messages: ${stats.totalMessages}`);
    console.log('==================\n');
  }
  
  displayRoom(roomId: number): void {
    const room = this.rooms.get(roomId);
    if (!room) {
      console.log('Room not found');
      return;
    }
    
    console.log(`\n=== Room: ${room.name} ===`);
    console.log(`Participants: ${room.participants.length}`);
    console.log('\nMessages:');
    
    room.messages.forEach(msg => {
      const sender = this.users.get(msg.senderId);
      const time = msg.timestamp.toLocaleTimeString();
      console.log(`[${time}] ${sender?.username}: ${msg.content}`);
    });
    
    console.log('='.repeat(30) + '\n');
  }
}

// メイン処理
function main(): void {
  console.log('=== TypeScript Chat Application ===\n');
  
  const app = new ChatApplication();
  
  // ユーザー登録
  const user1 = app.registerUser('田中太郎', 'tanaka@example.com');
  const user2 = app.registerUser('佐藤花子', 'sato@example.com');
  const user3 = app.registerUser('鈴木一郎', 'suzuki@example.com');
  
  // ログイン
  app.loginUser(user1.id);
  app.loginUser(user2.id);
  app.loginUser(user3.id);
  
  // チャットルーム作成
  const room = app.createRoom('開発チーム', user1.id);
  
  if (room) {
    // ルームに参加
    app.joinRoom(room.id, user2.id);
    app.joinRoom(room.id, user3.id);
    
    // メッセージイベントリスナー
    app.onMessage((message: Message) => {
      console.log(`[Event] New message received: ${message.content}`);
    });
    
    // メッセージ送信
    app.sendMessage(room.id, user1.id, 'みなさん、おはようございます！');
    app.sendMessage(room.id, user2.id, 'おはようございます！');
    app.sendMessage(room.id, user3.id, '今日のタスクについて話しましょう');
    app.sendMessage(room.id, user1.id, 'そうですね。まずはAPI開発から始めましょう');
    
    // ルーム表示
    app.displayRoom(room.id);
  }
  
  // 統計情報
  app.displayStatistics();
  
  // オンラインユーザー表示
  console.log('=== Online Users ===');
  app.getOnlineUsers().forEach(user => {
    console.log(`🟢 ${user.username}`);
  });
  
  // ログアウト
  app.logoutUser(user3.id);
  console.log('\n=== After Logout ===');
  app.getOnlineUsers().forEach(user => {
    console.log(`🟢 ${user.username}`);
  });
}

// エクスポート
export { ChatApplication, User, Message, ChatRoom };

// 実行
main();

