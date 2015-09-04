package vo
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * 服务器链接主类
	 * 2015/7/20
	 * James
	 */
	public class Connection
	{
		private var _HOST:String = "http://10.60.18.198";   //服务器地址
		private var _PORT:int = 1234;                                //端口
		private var _SOCKET:Socket;                                 //socket
		
		public function Connection()
		{
			_SOCKET = new Socket();
			_SOCKET.addEventListener(Event.CONNECT, SocketConnectEvent);                       //监听是否连接
			_SOCKET.addEventListener(Event.CLOSE, SocketCloseEvent);                               //监听连接关闭
			_SOCKET.addEventListener(IOErrorEvent.IO_ERROR, ioError);                              //监听连接关闭  
			_SOCKET.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityError);    //监听连接关闭
			_SOCKET.addEventListener(ProgressEvent.SOCKET_DATA,SocketDataEvent);          //监听接收数据
		}
		
		/**
		 * function: 开始链接SOCKET
		 */
		public function conn():void
		{
			_SOCKET.connect(_HOST,_PORT);
		}
		
		/**
		 * Socket链接成功事件
		 */
		private function SocketConnectEvent(event:Event):void
		{
			trace("链接成功");
		}

		/**
		 * Socket链接关闭事件
		 */
		private function SocketCloseEvent(event:Event):void
		{
			trace("链接关闭");
		}
		
		/**
		 * Socket返回数据事件
		 */
		private function SocketDataEvent(event:ProgressEvent):void
		{
		}
		
		/**
		 * Socket链接SecurityError事件
		 */
		private function SecurityError(event:SecurityErrorEvent):void
		{
			trace("securityError:" + event.text);
		}
		
		/**
		 * Socket链接ioError事件
		 */
		private function ioError(event:IOErrorEvent):void
		{
			trace("ioError:" + event.text);
		}
		
		/**
		 * Socket发送数据事件;
		 * value: 类型为ByteArray的参数;
		 * value参数Array内容INT值
		 * value参数ByteArray使用writeUTFBytes写入内容;
		 */
		public function SendData(ar:Array,ba:ByteArray):void
		{
			if(_SOCKET.connected && ar.length >= 1 && ba.length >= 1)
			{
				for(var i:int = 0; i < ar.length; i ++){
					_SOCKET.writeShort(ar[i]);
				}
				_SOCKET.writeBytes(ba);
				_SOCKET.flush();
			}
		}
	}
}