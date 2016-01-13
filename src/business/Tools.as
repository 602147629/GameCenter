package business
{
	import flash.filters.ColorMatrixFilter;
	import flash.utils.setTimeout;
	
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.managers.PopUpManager;
	import mx.utils.Base64Decoder;
	
	import spark.components.HGroup;
	import spark.components.Image;
	
	import vo.json.MYJSON;

	/**
	 * 工具类
	 * 2015/9/4
	 * James
	 */
	public class Tools
	{
		private var browser:IBrowserManager;
		private var md5:MD5;  
		//色值设置
		private var matrix:Array;
		private var colormat:ColorMatrixFilter;
	
		/**
		 * 获取浏览器URL的KEY值
		 * 返回值 浏览器参数之后的内容
		 */
		public function getUrl(vars:String):String
		{
			browser = BrowserManager.getInstance();
			browser.init(); 
			var str:String = 'http://10.60.22.39/GC/GameCenter_.html?p=eyJkYXRhIjp7InVzZXJpZCI6Ijg4OCIsInVzZXJrZXkiOiJ1bmRlZmluZWQiLCJzaXAiOiIxMC42MC4yMi4zOSIsInBvcnQiOiIxMjM0In19|#'
//			var str:String = browser.url;
			var index:int;
			index = str.indexOf(vars);
			var iend:int;
			iend = str.indexOf("|");
			if(index == -1) return null;
			else
			{
				return str.substring(index+3,iend);
			}
		}
		
		/**
		 * 获取socket头信息
		 */
		public function decode(h:int, l:int) : int
		{
			if (h<0){
				h = (0xff+h+1);
			}
			if (l<0){
				l = (0xff+l+1);
			}
			return (l*(0xff+1)+h);
		}
		
		/**
		 * 取高/低 位二字节编码
		 * vars: 需要转换的字节
		 * type: H高位/L低位
		 */
		public function getCode(vars:Number,type:String):Number
		{
			var num:Number;
			switch(type)
			{
				case "H" :
					num = vars >> 16;
					break;
				case "L" :
					num = vars & 65535;
					break;
			}
			return num;
		}
		
		/**
		 * MD5 加密
		 * vars：需要加密的内容
		 * 返回类型字符串
		 */
		public function getMd5(vars:String):String
		{
			md5 = new MD5();
			return md5.getMD5(vars);
		}
		
		/**
		 * 修改加载消息
		 */
		public function updateLoadMsg(strMsg:String,bytesLoaded:Number=0,bytesTotal:Number=0):void
		{
			(FlexGlobals.topLevelApplication.loadingTable).loading(strMsg,bytesLoaded,bytesTotal);
		}
		
		/**
		 * 遮罩窗口
		 * 消息，遮罩，关闭
		 */
		public function showWaiting(strMsg:String,modal:Boolean=true,closes:Boolean=false):void
		{
			if(closes == true)
			{
				FlexGlobals.topLevelApplication.waitMsg.removePop();
			}else{
				FlexGlobals.topLevelApplication.waitMsg.setMsg(strMsg);
				PopUpManager.addPopUp(FlexGlobals.topLevelApplication.waitMsg, FlexGlobals.topLevelApplication.disObj, modal);
				PopUpManager.centerPopUp(FlexGlobals.topLevelApplication.waitMsg);
			}
		}
		
		/**
		 * 获取浏览器授权信息
		 */
		public function getInfo():Object
		{
			var userParm:String = getUrl("?p=");
			if(userParm != ""){
				updateLoadMsg("获取授权信息...");
				var base64_d:Base64Decoder = new Base64Decoder();
				base64_d.decode(userParm);
				var Parm:String = base64_d.toByteArray().toString(); 
				var dataReust:Object = new Object();
				dataReust = MYJSON.decode(Parm);
				return dataReust;
			}else{
				updateLoadMsg("获取授权信息失败!");
				return null;
			}
		}
		
		/**
		 * 增加颜色
		 */
		public function setColor(mc:Image):void
		{
			matrix=new Array();
			matrix=matrix.concat([0,1,0,0,0]);//red
			matrix=matrix.concat([0,0,1,0,0]);//green
			matrix=matrix.concat([0,0,0,1,0]);//blue
			matrix=matrix.concat([0,0,0,1,0]);//alpha
			colormat = new ColorMatrixFilter(matrix);
			mc.filters=[colormat];
		}
		
		/**
		 * 清理颜色
		 */
		public function clearColor(mc:HGroup):void
		{
			var mcLength:int = mc.numChildren;
			for (var i:int = 0; i < mcLength; i++) 
			{
				var mcImage:Image = mc.getChildAt(i) as Image;
				mcImage.filters=[];
			}
		}
		
	}
}