package business
{
	import events.MainEvent;
	import events.UserEvent;
	
	import model.EventModel;
	import model.UserInfo;

	/**
	 * 用户登录授权类
	 * 2015/7/22
	 * James
	 */
	public class UserLogin
	{
		private var userInfo:UserInfo;
		private var userEvent:UserEvent;
		private var mainEvent:MainEvent;
		private var tool:Tools;
		
		public function UserLogin():void
		{
			mainEvent = new MainEvent();
			userEvent = new UserEvent();
			tool = new Tools();
			
			EventModel.dis.addEventListener(EventModel.USER_LOGIN,	userLoginEvent);
			EventModel.dis.addEventListener(EventModel.USERSOCKETDATA,socketDataEvent);
			
			mainEvent.initSocket("10.60.22.39",8090);
		}
		
		/**
		 * Socket链接数据返回
		 */
		private function socketDataEvent(event:EventModel):void
		{
			var dataReust:Object = new Object();
			dataReust = event.data;
			
			switch(dataReust.potocol)
			{
				case "6619736":
				{
					userLogin("kim","123qwe");
					break;
				}
				default:
				{
					//默认事件
					break;
				}
			}
		}
		
		/**
		 * 用户授权事件
		 */
		public function userLogin(username:String,userpwd:String):void
		{
			userInfo = new UserInfo();
			userInfo.GAMEID = 1;
			userInfo.PROTOCOL = 13107900;
			userInfo.SSHKEY = "123";
			userInfo.USERNAME = username;
			userInfo.PASSWORD = userpwd;
			
			userEvent.userLoginEvent(userInfo);
		}
		
		/**
		 * 用户授权事件回调
		 */
		private function userLoginEvent(event:EventModel):void
		{
			
		}
	}
}