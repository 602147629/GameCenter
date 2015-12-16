package events
{
	import flash.utils.ByteArray;
	
	import business.Tools;
	
	import model.EventModel;
	
	import vo.Connection;
	import vo.json.MYJSON;

	/**
	 * 事件主类
	 * 2015/9/10
	 * James
	 */
	public class MainEvent
	{
		private var connection:Connection = new Connection();
		private var eventModel:EventModel;                        //事件
		private var tool:Tools = new Tools;
		
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
		 * 断开Socket链接
		 */
		public function closeSocket():void
		{
			connection.SocketClose();
		}
		
		/**
		 * Socket链接数据返回
		 */
		private function socketDataEvent(event:EventModel):void
		{
				var dataReust:Object = new Object();
				trace("解析："+event.data as String);
				dataReust = MYJSON.decode(event.data as String);
				var prtcol:int = tool.getCode(dataReust.protocol,"L");
				trace("-------------------------------------------");
				trace(event.data as String);
				trace(prtcol);
				trace("-------------------------------------------");
				switch(prtcol){
					case 600:
					case 700:
						eventModel = new EventModel(EventModel.USERSOCKETDATA,false,false,dataReust);
						break;
					case 900:
						eventModel = new EventModel(EventModel.GAMESOCKETDATA,false,false,dataReust);
						break;
				}
				EventModel.dis.dispatchEvent(eventModel);
		}
		
		/**
		 * Socket链接错误
		 */
		private function socketErrorEvent(event:EventModel):void
		{
			trace(event.data);
		}
		
		/**
		 * Socket链接关闭
		 */
		private function socketCloseEvent(event:EventModel):void
		{
			trace("链接关闭");
			tool.updateLoadMsg("游戏服务器已经关闭！");
		}
		
		/**
		 * Socket链接写入
		 */
		public function socketWriteEvent(event:EventModel):void
		{
			var message:ByteArray=new ByteArray(); 
			message.writeUTFBytes(MYJSON.encode(event.data));
			connection.SendData(message);
		}
	}
}