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
		 * 成功连接游戏线路
		 * {"protocol":"6685272","data":{"type":"text/json"}}
		 */
		public static const LOGINSUSSFUL:String = "6685272";  
		
		/**
		 * 域授权登录成功
		 *  { "userid" : 888, "userkey" : 10, "agentkey" : 1, "protocol": 6685372, "errmsg": 999 } 
		 */
		public static const YULOGINSUSSFUL:String = "6685372";  
		
		/**
		 * 用户信息返回
		 *{"protocol":"8651452","agentkey":"1","userkey":"3","userid":"888","data":[{"points":"0","wons":"0","faileds":"0","aways":"0","name":"james"}]}
		 */
		public static const USERINFO:String = "8651452";  
		
		/**
		 * 发送用户信息
		 * （写入）
		 */
		public static const SENDUSERINFO:int = 6554300;  
	}
}