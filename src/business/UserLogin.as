package business
{
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;

	/**
	 * 用户登录授权类
	 * 2015/7/22
	 * James
	 */
	public class UserLogin
	{
		private var browser:IBrowserManager;
		
		public function UserLogin()
		{
			
		}
		
		/**
		 * 获取浏览器URL的KEY值
		 * 返回值 浏览器？之后的内容
		 */
		public function getUrl():String
		{
			browser = BrowserManager.getInstance();
			browser.init(); 
			var str:String = browser.url;
			var index:int;
			index = str.indexOf("?");
			if(index == -1) return null;
			else
			{
				return str.substr(index+1,str.length);
			}
		}
	}
}