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
		 * {"protocol":"42075012","userkey":"1","ranking":[{"rank":"1","name":"kim","rate":"80"}]}
		 */
		public static const DAYRANK:String = "42075012";     
		
		/**
		 * 周排行榜信息
		 * {"protocol":"41419652","ranking":[{"rank":"1","name":"protocoljames","rate":"60"},{"rank":"2","name":"sam","rate":"59"}]}
		 */
		public static const WEEKRANK:String = "41419652"; 
		
		/**
		 * 房间信息
		 *{"protocol":"40108932","tables":[{"roomid":"1","tableid":"1","doubles":"0","onlines":"120","dmoney":"600","name":"**"}]}"
		 */
		public static const ROOMLIST:String = "40108932"; 
		
		/**
		 * 在线人数
		 *{ "protocol":"40764292", "userkey":"78",  "Onlines":" 78 "  }
		 */
		public static const ONLINES:String = "40764292"; 
		
		/**
		 * 创建游戏副本
		 * {"protocol":"21037856", "userkey1":"2", "userkey2":"0", "userkey3":"0" ,"data":[{"status":"0","battleid":"2","seatid":"0" }] }
		 */
		public static const JOINGAME:String = "21037856"; 
		
		/**
		 * 发送进入游戏副本消息
		 * （写入）
		 */
		public static const SENDJOIN:int = 22283040; 
		
		/**
		 * 发送准备消息
		 * （写入）
		 */
		public static const BEREADY:int = 19661600; 
		
		/**
		 * 返回大厅消息
		 * （写入）
		 */
		public static const BACKLOBBY:int = 22938400;
		
		/**
		 * 获取牌信息
		 *{"protocol":"23659296", "data":{"battleid":"4","count":"3","poker":[-1],"seatid":"0","pokerinfo":[{"show":true,"name":"james","count":17,"poker":[4,7,9,10,13,15,17,21,26,27,29,30,32,33,40,45,47]},{"show":false,"name":"-","count":17,"poker":[-1]},{"show":false,"name":"-","count":17,"poker":[-1]}]}}
		 */
		public static const GETPOKER:String = '23659296'; 
		
		/**
		 * 叫地主推送
		 *{"protocol":"24970016", "data":{"battleid":"1","seatid":"0","multiple":"1","times":"16000","callinfo":[{"show":true},{"show":false},{"show":false}]}}
		 */
		public static const CALLBANK:String = "24970016"; 
		
		/**
		 * 叫地主
		 * （写入）
		 */
		public static const JIAODIZHU:int = 24249120;
		
		/**
		 * 完全版游戏内容信息
		 *{"protocol":"25625376", "data":{ "seatid":0, "battleid":1, "multiple":3, "dmodel":false, "banker":0, "count":3, "poker":[2,46,0],"bankerinfo":[{"show":true,"name":"james","count":19,"poker":[0,1,2,3,7,15,20,24,25,40,41,42,43,45,46,47,48,49,51]},{"show":false, "name":"17", "count":256, "poker":[-1] },{"show":false, "name":"17", "count":256, "poker":[-1] }]}}
		 */
		public static const POKERINFO:String = "25625376"; 
		
		/**
		 * 出牌推送
		 *{"protocol":"26936096", "data":{"seatid":0,"times":18,"basics":0,"multiple":3,"brokerage":500,"showcard":[{"show":false},{"show":true},{"show":false}]}}
		 */
		public static const YOURTURN:String = "26936096"; 
		
		/**
		 * 出牌
		 * （写入）
		 */
		public static const OUTCARD:int = 27525920;
		
		/**
		 * 出牌推送
		 *{"protocol":"27591456", "data":{ "seatid":0,  "battleid":1, "multiple":3, "dmodel":false, "count":3, "poker":[47,23,36], "bankerinfo":[{"show":true,"name":"james","count":20,"poker":[0,5,9,11,13,14,19,23,24,25,26,32,33,36,37,39,40,47,51,53]},{"show":false,"name":"unknow","count":17,"poker":[-1]},{"show":false,"name":"longsir","count":17,"poker":[-1]}] }}
		 */
		public static const OUTCARDSUSSFOR:String = "27591456"; 
	}
}