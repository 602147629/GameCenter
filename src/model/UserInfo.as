package model
{
	/**
	 * 用户类
	 * 2015/9/10
	 * James
	 */
	public class UserInfo
	{
		public var PROTOCOL:int;   //接口方法ID
		
		public var SSHKEY:String;   //平台密匙
		
		public var  GAMEID:int;     //游戏入口标识
		
		public var  USERID:int;     //游戏入口标识
		
		public var USERPORT:int;  // 备用方法表示
		
		public var USERIP:String;   //IP地址
		
		public var  USERKEY:String;    //key
		
		public var USERNAME:String;  //名
		
		public var USERMONEY:Number;   //钱
		
		public var USERRATE:int;  //胜率
		
		public var PASSWORD:String;   //备用密码
		
		public var USERWONS:Number;  //胜利数次
		
		public var USERFAILEDS:Number ;  //失败次数
		
		public var USERAWAYS:Number;  //离开次数
	}
}