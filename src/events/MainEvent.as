package events
{
	import flash.utils.ByteArray;
	
	import model.EventModel;
	
	import vo.Connection;

	/**
	 * 事件主类
	 * 2015/9/10
	 * James
	 */
	public class MainEvent
	{
		private var connection:Connection = new Connection();
		
		public function MainEvent()
		{
			EventModel.dis.addEventListener(EventModel.SOCKETDATA,socketDataEvent);
			EventModel.dis.addEventListener(EventModel.SOCKETERROR,socketErrorEvent);
			EventModel.dis.addEventListener(EventModel.SOCKETCLOSE,socketCloseEvent);
			EventModel.dis.addEventListener(EventModel.WRITESOCKET,socketWriteEvent);
		}
		
		/**
		 * 启动Socket链接
		 */
		public function initSocket(host:String,port:int):void
		{
			connection._HOST = host;
			connection._PORT = port;
			connection.conn(); //开始链接数据库
		}
		
		/**
		 * Socket链接数据返回
		 */
		private function socketDataEvent(event:EventModel):void
		{
			trace(event.data);
		}
		
		/**
		 * Socket链接错误
		 */
		private function socketErrorEvent(event:EventModel):void
		{
			
		}
		
		/**
		 * Socket链接关闭
		 */
		private function socketCloseEvent(event:EventModel):void
		{
			
		}
		
		/**
		 * Socket链接写入
		 */
		public function socketWriteEvent(event:EventModel):void
		{
			var msg:ByteArray = event.data as ByteArray;
			connection.SendData(msg);
		}
	}
}