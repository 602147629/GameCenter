package business.ddz
{
	/**
	 * 斗地主游戏常量
	 * 2015/107
	 * James
	 */
	
	public class SocketConst
	{
		/**
		 * 日排行榜信息
		 * {"protocol":"33489796","userkey":"1","ranking":[{"rank":"1","name":"kim","rate":"80"}]}
		 */
		public static const DAYRANK:String = "33489796";     
		
		/**
		 * 周排行榜信息
		 * {"protocol":"33686404","ranking":[{"rank":"1","name":"protocoljames","rate":"60"},{"rank":"2","name":"sam","rate":"59"}]}
		 */
		public static const WEEKRANK:String = "33686404"; 
		
		/**
		 * 房间信息
		 *{"protocol":"33096580","tables":[{"roomid":"1","tableid":"1","doubles":"0","onlines":"120","dmoney":"600","name":"**"}]}"
		 */
		public static const ROOMLIST:String = "33096580"; 
		
		/**
		 * 在线人数
		 *{ "protocol":"33293188", "userkey":"78",  "Onlines":" 78 "  }
		 */
		public static const ONLINES:String = "33293188"; 
	}
}