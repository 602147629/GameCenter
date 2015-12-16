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
		 *  { "userid" : 888, "userkey" : 10, "agentkey" : 1, "protocol": 19792572, "errmsg": 999 } 
		 */
		public static const YULOGINSUSSFUL:String = "19792572";  
		
		/**
		 * 用户信息返回
		 *{"protocol":"33883012","agentkey":"1","userkey":"3","userid":"888","data":[{"points":"0","wons":"0","faileds":"0","aways":"0","name":"james"}]}
		 */
		public static const USERINFO:String = "20644540";  
	}
}