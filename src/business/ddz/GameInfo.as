package business.ddz
{
	/**
	 * 斗地主游戏逻辑
	 * 2015/10/2
	 * James
	 */
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TileGroup;
	import spark.components.VGroup;
	
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
				case "33358724": 	//日排行榜信息
					(FlexGlobals.topLevelApplication.MainModule.child).dayRankArray = dataReust.ranking as Array;
					setRankData(dataReust.ranking as Array);
					break;
				case "33162116": //周排行榜信息
					(FlexGlobals.topLevelApplication.MainModule.child).weekRankArray = dataReust.ranking as Array;
					break;
				case "32768900": //房间信息
					(FlexGlobals.topLevelApplication.MainModule.child).roomArray = dataReust.tables as Array;
					setRoomData(dataReust.tables as Array);
					break;
				default:
				{
					//默认事件
					break;
				}
			}
		}
		
		/**
		 * 绘制排行榜
		 */
		public function setRankData(dataArray:Array):void
		{
			var vg:VGroup = (FlexGlobals.topLevelApplication.MainModule.child).dataRank;
			vg.removeAllElements();
			vg.gap = 2;
			for each(var item:Object in dataArray)
			{
				var hg:HGroup = new HGroup();
				var ng:HGroup = new HGroup();
				var nametxt:Label = new Label();
				var ratetxt:Label = new Label();
				ng.width = 85;
				ng.horizontalAlign = "center";
				hg.paddingLeft = 63;
				hg.gap = 17;
				if(item.rank <= 3){
					hg.styleName = "ranktop";
				}else{
					hg.styleName = "ranknom";
				}
				ratetxt.width = 35;
				nametxt.text = item.name;
				ratetxt.text = item.rate + "%";
				hg.height = 22;
				hg.verticalAlign = "middle";
				ng.addElement(nametxt);
				hg.addElement(ng);
				hg.addElement(ratetxt);
				vg.addElement(hg);
			}
		}
		
		/**
		 * 绘制房间
		 */
		public function setRoomData(dataArray:Array):void
		{
			var tg:TileGroup = (FlexGlobals.topLevelApplication.MainModule.child).room;
			var assets:Object = FlexGlobals.topLevelApplication.assetsObject;
			tg.removeAllElements();
			(FlexGlobals.topLevelApplication.MainModule.child).changeSelect("Btn_"+ dataArray[0].type);
			
			for each(var item:Object in dataArray)
			{
				var gp:Group = new Group();
				var imgbg:Image = new Image();
				imgbg.source = assets.room_list_bg;
				var imgico:Image = new Image();
				imgico.source = assets.icon_01;
				imgico.x = 20;
				imgico.y = 20;
				var imgtype:Image = new Image();
				if(item.double ==  0){
					imgtype.source = assets.ordinary;
				}else{
					imgtype.source = assets.double;
				}
				imgtype.x = 300;
				imgtype.y = 00;
				var roomtxt:Label = new Label();
				roomtxt.styleName = "roomid";
				roomtxt.text = item.index;
				roomtxt.x = 120;
				roomtxt.y = 10;
				var ulimittxt:Label = new Label();
				ulimittxt.styleName = "roominfo";
				ulimittxt.text = "底注：" + item.ulimit;
				ulimittxt.x = 120;
				ulimittxt.y = 54;
				var onlinestxt:Label = new Label();
				onlinestxt.styleName = "roominfo";
				onlinestxt.text = "在线：" + item.onlines + "人";
				onlinestxt.x = 203;
				onlinestxt.y = 54;
				var imgbtn:Image = new Image();
				imgbtn.source = assets.btn_start;
				imgbtn.buttonMode = true;
				imgbtn.addEventListener(MouseEvent.MOUSE_OVER, function (evt:MouseEvent):void{
					(evt.currentTarget as Image).source = assets.btn_start_hover;
				});
				imgbtn.addEventListener(MouseEvent.MOUSE_OUT, function (evt:MouseEvent):void{
					(evt.currentTarget as Image).source = assets.btn_start;
				});
				imgbtn.x = 125;
				imgbtn.y = 85;
				
				gp.addElement(imgbg);
				gp.addElement(imgico);
				gp.addElement(imgtype);
				gp.addElement(roomtxt);
				gp.addElement(ulimittxt);
				gp.addElement(onlinestxt);
				gp.addElement(imgbtn);
				tg.addElement(gp);
			}
		}
		
	}
}