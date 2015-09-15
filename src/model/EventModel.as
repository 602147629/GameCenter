package model
{
	/**
	 * 用户登录授权事件类
	 * 2015/7/22
	 * James
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class EventModel extends Event
	{  
		/**
		 * Socket 数据返回
		 */
		public static const SOCKETDATA:String = "SocketData";  
		
		/**
		 * Socket 数据返回
		 */
		public static const SOCKETERROR:String = "SocketError";  
		
		/**
		 * Socket 数据返回
		 */
		public static const SOCKETCLOSE:String = "SocketClose";  
		
		/**
		 * 登录事件
		 */
		public static const USER_LOGIN:String = "UserLogin"; 
		
		/**
		 * 写入事件
		 */
		public static const WRITESOCKET:String = "WriteSocket"; 
		
		/**
		 * 用户事件数据返回
		 */
		public static const USERSOCKETDATA:String = "UserSocketData"; 
		
		/**
		 * 派发器
		 */
		public static const dis:EventDispatcher = new EventDispatcher();
		
		/**
		 * 参数
		 */
		public var data:Object;
		
		public function EventModel(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object = null)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}