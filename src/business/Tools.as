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
	}
}