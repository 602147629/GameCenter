package business
{
	import events.MainEvent;

	public class Main
	{
		private var mainEvent:MainEvent = new MainEvent();
		/**
		 * 初始化
		 */
		public function Main()
		{
			mainEvent.initSocket();
		}
	}
}