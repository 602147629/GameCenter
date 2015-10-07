package vo
{
	/**
	 * 登录常量
	 * 2015/107
	 * James
	 */
	public class LoginConst
	{
		/**
		 * 域登录信息
		 * {"protocol":"6619736","data":{"type":"text/json"}}
		 */
		public static const YULOGIN:String = "6619736";  
		
		/**
		 * 域授权登录成功
		 * {"protocol":"13173436","data":{"userid":"555","userkey":"f48db3cd91ebb288ff33e95493b6329b","sip":"10.60.22.39","port":"1234"}}
		 */
		public static const YULOGINSUSSFUL:String = "13173436";  
		
		/**
		 * 成功连接游戏线路
		 * {"protocol":"6685272","data":{"type":"text/json"}}
		 */
		public static const LOGINSUSSFUL:String = "6685272";  
		
		/**
		 * 用户信息返回
		 * {"protocol":"19792572","userinfo":[{"name":"james","money":"8000","rate":"60"}]}
		 */
		public static const USERINFO:String = "19792572";  
	}
}