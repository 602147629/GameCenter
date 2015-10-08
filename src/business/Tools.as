package business
{
	import flash.display.DisplayObjectContainer;
	
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.managers.PopUpManager;
	import mx.utils.Base64Decoder;
	
	import view.Waiting;
	
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
	
		/**
		 * 获取浏览器URL的KEY值
		 * 返回值 浏览器参数之后的内容
		 */
		public function getUrl(vars:String):String
		{
			browser = BrowserManager.getInstance();
			browser.init(); 
			var str:String = browser.url;
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
		public function updateLoadMsg(strMsg:String):void
		{
			FlexGlobals.topLevelApplication.msg.text = strMsg;
		}
		
		/**
		 * 修改加载消息
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
			//var userParm:String = "eyJkYXRhIjp7InVzZXJpZCI6Ijg4OCIsInVzZXJrZXkiOiI2MGQyZDVlMWZjNmVkNTMyZjE3NWQ2MzMyNDBiMjA3NSIsInNpcCI6IjEwLjYwLjIyLjM5IiwicG9ydCI6IjEyMzQifX0=";
			if(userParm != ""){
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
		
	}
}