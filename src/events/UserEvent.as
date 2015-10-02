package events
{
	import flash.utils.ByteArray;
	import model.EventModel;
	import model.UserInfo;
	import vo.json.MYJSON;

	/**
	 * 用户事件类
	 * 2015/9/10
	 * James
	 */
	public class UserEvent
	{
		private var eventModel:EventModel;
		
		/**
		 * 用户逻辑使用的事件
		 */
		public function userLoginEvent(user:UserInfo):void
		{
			var message:ByteArray=new ByteArray(); 
			message.writeUTFBytes(MYJSON.encode(user));
			writeSocket(message);
		}
		
		/**
		 * 用户类专用写入事件
		 * 参数：ByteArray
		 */
		private function writeSocket(data:ByteArray):void
		{
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false, data);
			EventModel.dis.dispatchEvent(eventModel);
		}
	}
}