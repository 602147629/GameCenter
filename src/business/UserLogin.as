package business
{
	import mx.core.FlexGlobals;
	
	import events.MainEvent;
	import events.UserEvent;
	
	import model.EventModel;
	import model.UserInfo;
	
	import vo.LoginConst;

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
			
			mainEvent.initSocket("10.60.22.39",8090); //网络入口链接 域登录服务器。
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
				case LoginConst.YULOGIN:
				{
					userLogin("kim","123qwe");
					break;
				}
				case LoginConst.YULOGINSUSSFUL:
				{
					userSuccessful(dataReust.data);
					break;
				}
				case LoginConst.LOGINSUSSFUL:
				{
					trace("成功连接游戏线路");
					tool.updateLoadMsg("正在进入游戏中，请稍后...");
					getUserInfo();
					break;
				}
				case LoginConst.USERINFO: 
				{
					userInfo.PROTOCOL = 19727036;
					userInfo.USERNAME = dataReust.userinfo[0].name;
					userInfo.USERMONEY = dataReust.userinfo[0].money;
					userInfo.USERRATE = dataReust.userinfo[0].rate;
					(FlexGlobals.topLevelApplication.HeadModule.child).setUserParam(userInfo);
					FlexGlobals.topLevelApplication.pageView.selectedIndex = 1;
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
			tool.showWaiting("初始化数据中...",false);
			userInfo.PROTOCOL = 19661500;
			userEvent.userLoginEvent(userInfo);
		}
	}
}