package events
{
	import model.EventModel;
	import model.UserInfo;
	
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
			writeSocket(user);
		}
		
		/**
		 * 用户类专用写入事件
		 * 参数：ByteArray
		 */
		private function writeSocket(data:Object):void
		{
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false, data);
			EventModel.dis.dispatchEvent(eventModel);
		}
	}
}