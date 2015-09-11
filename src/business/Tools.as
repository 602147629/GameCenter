package business
{
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;

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
			if(index == -1) return null;
			else
			{
				return str.substr(index+1,str.length);
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
	}
}