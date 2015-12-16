package business.ddz
{
	/**
	 * 斗地主游戏逻辑
	 * 2015/10/2
	 * James
	 */
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TileGroup;
	import spark.components.VGroup;
	import spark.effects.Fade;
	
	import business.Tools;
	
	import model.EventModel;
	
	import vo.json.MYJSON;
	
	public class GameInfo
	{
		private var tools:Tools = new Tools();
		private var eventModel:EventModel;                        //事件
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
		 * 方法目录（重要）
		 */
		private function socketDataEvent(event:EventModel):void
		{
			var dataReust:Object = new Object();
			dataReust = event.data;
			switch(dataReust.protocol)
			{
				case SocketConst.DAYRANK: 	//日排行榜信息
					(FlexGlobals.topLevelApplication.MainModule.child).dayRankArray = dataReust.ranking as Array;
					setRankData(dataReust.ranking as Array);
					break;
				case SocketConst.WEEKRANK: //周排行榜信息
					(FlexGlobals.topLevelApplication.MainModule.child).weekRankArray = dataReust.ranking as Array;
					break;
				case SocketConst.ROOMLIST: //房间信息
					(FlexGlobals.topLevelApplication.MainModule.child).roomArray = dataReust.tables as Array;
					setRoomData(dataReust.tables as Array);
					break;
				case SocketConst.ONLINES: //在线信息
					(FlexGlobals.topLevelApplication.HeadModule.child).initPeople(dataReust.Onlines);
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
			vg.gap = 0.8;
			for each(var item:Object in dataArray)
			{
				var ng:HGroup = new HGroup();
				var lg:HGroup = new HGroup();
				var nametxt:Label = new Label();
				var ratetxt:Label = new Label();
				ng.width = 180;
				ng.height = 23;
				ng.horizontalAlign = "right";
				ng.paddingLeft = 80;
				if(item.rank <= 3){
					ng.styleName = "ranktop";
				}
				else if(item.rank > 8){
					ng.styleName = "ranknom";
					ng.height = 24;
				}else{
					ng.styleName = "ranknom";
				}
				ratetxt.width = 35;
				nametxt.maxDisplayedLines = 15;
				nametxt.text = item.name;
				ratetxt.text = item.rate + "%";
				ng.verticalAlign = "middle";
				lg.width = 105;
				lg.horizontalAlign = "center";
				lg.addElement(nametxt);
				ng.addElement(lg);
				ng.addElement(ratetxt);
				vg.addElement(ng);
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
			var sr:String = (FlexGlobals.topLevelApplication.MainModule.child).selectRoomId;
			(FlexGlobals.topLevelApplication.MainModule.child).changeSelect(sr);
			for each(var item:Object in dataArray)
			{
				if(item.roomid == sr)
				{
					var gp:Group = new Group();
					var imgbg:Image = new Image();
					imgbg.source = assets.room_list_bg;
					var imgico:Image = new Image();
					imgico.source = assets.icon_01;
					imgico.x = 20;
					imgico.y = 20;
					var imgtype:Image = new Image();
					if(item.doubles ==  0){
						imgtype.source = assets.ordinary;
					}else{
						imgtype.source = assets.double;
					}
					imgtype.x = 265;
					imgtype.y = 00;
					var roomtxt:Label = new Label();
					roomtxt.styleName = "roomid";
					roomtxt.text = item.name;
					roomtxt.x = 120;
					roomtxt.y = 10;
					var ulimittxt:Label = new Label();
					ulimittxt.styleName = "roominfo";
					ulimittxt.text = "底注：" + item.dmoney;
					ulimittxt.x = 125;
					ulimittxt.y = 48;
					var onlinestxt:Label = new Label();
					onlinestxt.styleName = "roominfo";
					onlinestxt.text = "在线：" + item.onlines + "人";
					onlinestxt.x = 205;
					onlinestxt.y = 48;
					var imgbtn:Image = new Image();
					imgbtn.source = assets.btn_start;
					imgbtn.buttonMode = true;
					imgbtn.name = item.tableid;
					imgbtn.addEventListener(MouseEvent.MOUSE_OVER, function (evt:MouseEvent):void{
						(evt.currentTarget as Image).source = assets.btn_start_hover;
					});
					imgbtn.addEventListener(MouseEvent.MOUSE_OUT, function (evt:MouseEvent):void{
						(evt.currentTarget as Image).source = assets.btn_start;
					});
					imgbtn.addEventListener(MouseEvent.CLICK, joinRoom);
					imgbtn.x = 135;
					imgbtn.y = 78;
					
					gp.addElement(imgbg);
					gp.addElement(imgico);
					gp.addElement(imgtype);
					gp.addElement(roomtxt);
					gp.addElement(ulimittxt);
					gp.addElement(onlinestxt);
					gp.addElement(imgbtn);
					gp.addEventListener(Event.ADDED_TO_STAGE,function (e:Event):void
					{
						var fadein:Fade = new Fade();
						fadein.alphaFrom = 0;
						fadein.alphaTo = 1;
						fadein.duration = 1000;
						fadein.target = (e.currentTarget as Group);
						fadein.play();
					});
					gp.addEventListener(Event.REMOVED_FROM_STAGE,function (e:Event):void
					{
						var fadeout:Fade = new Fade();
						fadeout.alphaFrom = 1;
						fadeout.alphaTo = 0;
						fadeout.duration = 1000;
						fadeout.target = (e.currentTarget as Group);
						fadeout.play();
					});
					tg.addElement(gp);
				}
			}
		}
		
		/**
		 * 进入房间
		 */
		private function joinRoom(event:MouseEvent):void
		{
			FlexGlobals.topLevelApplication.gameBg.source = FlexGlobals.topLevelApplication.assetsObject.game_bg;
			FlexGlobals.topLevelApplication.GameModule.loadModule("view/ddz/Gameing.swf");
			var obj:Object = new Object();
			obj.protocol = 131859232;
			obj.userid = (FlexGlobals.topLevelApplication.HeadModule.child).userInfo.USERID;
			obj.roomid = (FlexGlobals.topLevelApplication.MainModule.child).selectRoomId;
			obj.tableid = (event.currentTarget as Image).name;
			
			trace(ObjectUtil.toString(obj));
			
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
		}
		
		/**
		 * 返回大厅
		 */
		public function backIndex():void
		{
			FlexGlobals.topLevelApplication.GameModule.unloadModule();
			FlexGlobals.topLevelApplication.pageView.selectedIndex = 1;
		}
				
	}
}