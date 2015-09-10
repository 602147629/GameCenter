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
		
		public function UserLogin():void
		{
			mainEvent = new MainEvent();
			userEvent = new UserEvent();
			
			EventModel.dis.addEventListener(EventModel.USER_LOGIN,	userLoginEvent);
			
			mainEvent.initSocket("10.60.22.39",1234);
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