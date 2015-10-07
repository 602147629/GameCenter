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
		 * {"protocol":"33358724","ranking":[{"rank":"1","name":"protocoljames","rate":"60"},{"rank":"2","name":"sam","rate":"59"}]}
		 */
		public static const DAYRANK:String = "33358724";     
		
		/**
		 * 周排行榜信息
		 * {"protocol":"33162116","ranking":[{"rank":"1","name":"protocoljames","rate":"60"},{"rank":"2","name":"sam","rate":"59"}]}
		 */
		public static const WEEKRANK:String = "33162116"; 
		
		/**
		 * 房间信息
		 *{"protocol":"32768900","tables":[{"type":"1","index":"1","double":"0","onlines":"120","ulimit":"600"}]}"
		 */
		public static const ROOMLIST:String = "32768900"; 
	}
}