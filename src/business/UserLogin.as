package business
{
	import mx.core.FlexGlobals;
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
			
			switch(dataReust.protocol)
			{
				case "6619736":
				{
					//域登录信息发送
					userLogin("kim","123qwe");
					break;
				}
				case "13173436":
				{
					//授权成功连接线路
					userSuccessful(dataReust.data);
					break;
				}
				case "6685272":
				{
					//成功连接游戏线路
					trace("成功连接游戏线路");
					getUserInfo();
					FlexGlobals.topLevelApplication.pageView.selectedIndex = 1;
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
			userInfo.GAMEID = 2; 
			userInfo.PROTOCOL = 13107900;
			userInfo.SSHKEY = "123";
			userInfo.USERNAME = username;
			userInfo.PASSWORD = userpwd;
			
			userEvent.userLoginEvent(userInfo);
		}
		
		/**
		 * 用户授权成功连接
		 */
		public function userSuccessful(user:Object):void
		{
			userInfo.USERID = user.userid;
			userInfo.USERPORT = user.port;
			userInfo.USERIP = user.sip;
			userInfo.USERKEY = user.userkey;
			
			mainEvent.closeSocket();
			mainEvent.initSocket(userInfo.USERIP,userInfo.USERPORT);
		}
		
		/**
		 * 初次登陆用户信息
		 */
		private function getUserInfo():void
		{
			userInfo.PROTOCOL = 19661500;
			userEvent.userInfoEvent(userInfo);
		}
	}
}