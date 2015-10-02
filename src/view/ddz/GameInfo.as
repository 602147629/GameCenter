package view.ddz
{
	/**
	 * 斗地主游戏逻辑
	 * 2015/10/2
	 * James
	 */
	import model.EventModel;

	public class GameInfo
	{
		/**
		 * 添加监听
		 */
		public function addEventGAME():void
		{
			if(EventModel.dis.hasEventListener(EventModel.GAMESOCKETDATA) == false){
				EventModel.dis.addEventListener(EventModel.GAMESOCKETDATA,socketDataEvent);
			}
		}
		
		/**
		 * Socket链接数据返回
		 */
		private function socketDataEvent(event:EventModel):void
		{
			var dataReust:Object = new Object();
			dataReust = event.data;
			switch(dataReust.protocol)
			{
				case "32899972": 	//日排行榜信息
					trace("获取到"+ (dataReust.ranking as Array).length + "条排行榜信息！");
					break;
				case "32834436": //周排行榜信息
					break;
				case "32768900": //房间信息
					break;
				default:
				{
					//默认事件
					break;
				}
			}
		}
	}
}