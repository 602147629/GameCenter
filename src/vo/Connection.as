package vo
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import mx.utils.ObjectUtil;
	import model.EventModel;
	
	
	/**
	 * 服务器链接主类
	 * 2015/7/20
	 * James
	 */
	public class Connection
	{
		public var _HOST:String;                                      //服务器地址
		public var _PORT:int;                                           //端口
		private var _SOCKET:Socket;                                 //socket
		private var _Timer:Timer;
		
		private var eventModel:EventModel;                        //事件
		
		public function Connection()
		{
			flash.system.Security.allowDomain("*"); 
			flash.system.Security.loadPolicyFile("xmlsocket://10.60.22.39:843");                    //策略文件
			
			_SOCKET = new Socket();
			_SOCKET.timeout = 10000;                                                                              //链接超时10秒
			_SOCKET.addEventListener(Event.CONNECT, SocketConnectEvent);                       //监听是否连接
			_SOCKET.addEventListener(Event.CLOSE, SocketCloseEvent);                               //监听连接关闭
			_SOCKET.addEventListener(IOErrorEvent.IO_ERROR, ioError);                              //出现输入/输出错误并由此导致连接失败
			_SOCKET.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecurityError);    //连接目标服务器失败
			_SOCKET.addEventListener(ProgressEvent.SOCKET_DATA,SocketDataEvent);          //监听接收数据
		}
		
		/**
		 * function: 开始链接SOCKET
		 */
		public function conn():void
		{
			if(_SOCKET.connected != true)
			{
				_SOCKET.connect(_HOST, _PORT);
				_Timer=new Timer(5000);
				_Timer.addEventListener(TimerEvent.TIMER, function(event:TimerEvent):void {
					_SOCKET.connect(_HOST, _PORT);
					(event.currentTarget as Timer).stop();
				})
				_Timer.start();
			}
		}
		
		/**
		 * Socket链接成功事件
		 */
		private function SocketConnectEvent(event:Event):void
		{
			_Timer.stop();
		}
		
		/**
		 * Socket链接关闭
		 */
		public function SocketClose():void
		{
			if(_SOCKET.connected == true)
			{
				_SOCKET.close();
			}
		}
		
		/**
		 * Socket链接关闭事件
		 */
		private function SocketCloseEvent(event:Event):void
		{
			eventModel = new EventModel(EventModel.SOCKETCLOSE,false,false, null);
			EventModel.dis.dispatchEvent(eventModel);
			_Timer.stop();
		}
		
		/**
		 * Socket返回数据事件
		 */
		private function SocketDataEvent(event:ProgressEvent):void
		{
			var readData:String;
			while (_SOCKET.bytesAvailable) {
				readData=_SOCKET.readUTFBytes(_SOCKET.bytesAvailable);
			}
			
			eventModel = new EventModel(EventModel.SOCKETDATA,false,false,readData);
			EventModel.dis.dispatchEvent(eventModel);
		}
		
		/**
		 * Socket链接SecurityError事件
		 */
		private function SecurityError(event:SecurityErrorEvent):void
		{
			eventModel = new EventModel(EventModel.SOCKETERROR,false,false, event.text + "-" + event.type);
			EventModel.dis.dispatchEvent(eventModel);
			_Timer.start();
		}
		
		/**
		 * Socket链接ioError事件
		 */
		private function ioError(event:IOErrorEvent):void
		{
			eventModel = new EventModel(EventModel.SOCKETERROR,false,false, event.text + "-" + event.type);
			EventModel.dis.dispatchEvent(eventModel);
			_Timer.start();
		}
		
		/**
		 * Socket发送数据事件;
		 * value: 类型为ByteArray的参数;
		 * value参数Array内容INT值
		 * value参数ByteArray使用writeUTFBytes写入内容;
		 */
		public function SendData(ba:ByteArray):void
		{
			if(_SOCKET.connected  && ba.length >= 1)
			{
				_SOCKET.writeBytes(ba);
				_SOCKET.flush();
			}else{
				trace("SOCKET消息发送失败！服务器状态："+_SOCKET.connected + "传输内容："+ObjectUtil.toString(ba));
			}
		}
	}
}