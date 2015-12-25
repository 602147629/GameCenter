package business.ddz
{
	/**
	 * 斗地主游戏逻辑
	 * 2015/10/2
	 * James
	 */
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.effects.Move;
	import mx.utils.ObjectUtil;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.TileGroup;
	import spark.components.VGroup;
	import spark.effects.Fade;
	
	import business.Tools;
	
	import model.EventModel;
	
	public class GameInfo
	{
		private var tools:Tools = new Tools();
		private var eventModel:EventModel;                        //事件
		private var assets:Object = FlexGlobals.topLevelApplication.assetsObject;
		
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
				case SocketConst.JOINGAME: //加入游戏
					FlexGlobals.topLevelApplication.tableInfo.DATA = dataReust.data;
					FlexGlobals.topLevelApplication.tableInfo.PROTOCOL = dataReust.protocol;
					if(FlexGlobals.topLevelApplication.GameModule.url != null){(FlexGlobals.topLevelApplication.GameModule.child).gameingData();}
					initTable();
					break;
				case SocketConst.GETPOKER: //获取游戏牌信息 （游戏开始）
					trace("游戏开始");
					initMyPoker(dataReust.data);
					break;
				case SocketConst.CALLBANK: // 叫地主
					trace("叫地主");
					initBank(dataReust.data);
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
					gp.addEventListener(Event.ADDED_TO_STAGE,fadein);
					gp.addEventListener(Event.REMOVED_FROM_STAGE,fadeout);
					tg.addElement(gp);
				}
			}
		}
		
		/**
		 * 淡出
		 */
		private function fadeout(e:Event):void
		{
			var fadeout:Fade = new Fade();
			fadeout.alphaFrom = 1;
			fadeout.alphaTo = 0;
			fadeout.duration = 1000;
			fadeout.target = (e.currentTarget as Group);
			fadeout.play();
		}
		/**
		 * 淡入
		 */
		private function fadein(e:Event):void
		{
			var fadein:Fade = new Fade();
			fadein.alphaFrom = 0;
			fadein.alphaTo = 1;
			fadein.duration = 1000;
			fadein.target = (e.currentTarget as Group);
			fadein.play();
		}
		
		/**
		 * 进入房间
		 */
		private function joinRoom(event:MouseEvent):void
		{
			var obj:Object = new Object();
			obj.protocol = SocketConst.SENDJOIN;
			obj.userid = (FlexGlobals.topLevelApplication.HeadModule.child).userInfo.USERID;
			obj.roomid = (FlexGlobals.topLevelApplication.MainModule.child).selectRoomId;
			obj.tableid = (event.currentTarget as Image).name;
			
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
			
			//等待
			tools.showWaiting("正在进入游戏中...");
		}
		
		/**
		 * 初始化副本
		 */
		private function initTable():void
		{
			tools.showWaiting("",true,true);
			FlexGlobals.topLevelApplication.gameBg.source = FlexGlobals.topLevelApplication.assetsObject.game_bg;
			FlexGlobals.topLevelApplication.GameModule.loadModule("view/ddz/Gameing.swf");
			trace("加载游戏模块");
		}
		
		/**
		 * 返回大厅
		 */
		public function backIndex():void
		{
			var obj:Object = new Object();
			obj.protocol = SocketConst.BACKLOBBY;
			obj.battleid = FlexGlobals.topLevelApplication.tableInfo.DATA[0].battleid;
			obj.seatid = FlexGlobals.topLevelApplication.tableInfo.DATA[0].seatid;
			
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
			
			FlexGlobals.topLevelApplication.GameModule.url = null;
			FlexGlobals.topLevelApplication.GameModule.unloadModule();
			FlexGlobals.topLevelApplication.pageView.selectedIndex = 1;
		}
		
		/**
		 * 绘画用户按钮区
		 */
		public function initBtns(type:int,myg:HGroup):void
		{
			myg.removeAllElements();
			myg.visible = true;
			trace("初始化按钮："+type);
			switch(type)
			{
				case 1:
				{
					//绘画换桌,准备按钮
					var btn1:Image = new Image();
					btn1.buttonMode = true;
					btn1.source = assets.btn_change;
					
					var btn2:Image = new Image();
					btn2.buttonMode = true;
					btn2.source = assets.btn_startGame;
					btn2.addEventListener(MouseEvent.CLICK,readyBtn);
					myg.addElement(btn1);
					myg.addElement(btn2);
					break;
				}
				case 2:
				{
					//绘画抢地主,不抢按钮
					var btn3:Image = new Image();
					btn3.buttonMode = true;
					btn3.source = assets.btn_dun_call;
					
					var btn4:Image = new Image();
					btn4.buttonMode = true;
					btn4.source = assets.btn_prompt;
					
					myg.addElement(btn3);
					myg.addElement(btn4);
					break;
				}
				case 4:
				{
					//绘画1/2/3 分  不抢按钮
					var btn5:Image = new Image();
					btn5.buttonMode = true;
					btn5.source = assets.btn_one;
					
					var btn6:Image = new Image();
					btn6.buttonMode = true;
					btn6.source = assets.btn_two;
					
					var btn7:Image = new Image();
					btn7.buttonMode = true;
					btn7.source = assets.btn_three;
					
					var btn8:Image = new Image();
					btn8.buttonMode = true;
					btn8.source = assets.btn_dun_call;
					btn8.addEventListener(MouseEvent.CLICK,buJiaoClick);
					
					myg.addElement(btn5);
					myg.addElement(btn6);
					myg.addElement(btn7);
					myg.addElement(btn8);
					break;
				}
			}
			myg.addEventListener(Event.ADDED_TO_STAGE,fadein);
			myg.addEventListener(Event.REMOVED_FROM_STAGE,fadeout);
		}
		
		/**
		 * 准备按钮事件
		 */
		private function readyBtn(evt:MouseEvent):void
		{
			var obj:Object = new Object();
			obj.protocol = SocketConst.BEREADY;
			obj.status = 0;  //是否名牌准备
			obj.battleid = FlexGlobals.topLevelApplication.tableInfo.DATA[0].battleid;
			obj.seatid = FlexGlobals.topLevelApplication.tableInfo.DATA[0].seatid;
				
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
		}
		
		/**
		 * 绘制手牌
		 * 开始游戏
		 */
		private var selectPoker:ArrayCollection;  //选中牌组
		private var pokerImg:Array = new Array(assets.poker0,assets.poker1,assets.poker2,assets.poker3,assets.poker4,assets.poker5,assets.poker6,assets.poker7,assets.poker8,assets.poker9,assets.poker10,assets.poker11,assets.poker12,assets.poker13,assets.poker14,assets.poker15,assets.poker16,assets.poker17,assets.poker18,assets.poker19,assets.poker20,assets.poker21,assets.poker22,assets.poker23,assets.poker24,assets.poker25,assets.poker26,assets.poker27,assets.poker28,assets.poker29,assets.poker30,assets.poker31,assets.poker32,assets.poker33,assets.poker34,assets.poker35,assets.poker36,assets.poker37,assets.poker38,assets.poker39,assets.poker40,assets.poker41,assets.poker42,assets.poker43,assets.poker44,assets.poker45,assets.poker46,assets.poker47,assets.poker48,assets.poker49,assets.poker50,assets.poker51,assets.poker52,assets.poker53);
		public function initMyPoker(pokerObj:Object):void
		{
			starGameView();   //开始游戏界面
			selectPoker = new ArrayCollection();
			var  mySeat:int = pokerObj.seatid;
			var myPokerArr:ArrayCollection = new ArrayCollection();
			for each(var pk:int in pokerObj.pokerinfo[mySeat].poker)
			{
				var img:Image = new Image();
				img.source = pokerImg[pk];
				img.name = 'poker'+pk;
				img.width = 70;
				img.height = 90;
				img.addEventListener(MouseEvent.CLICK,pokerClick);
				
				var obj:Object = new Object();
				if(pk == 52 || pk == 53){
					pk = 12.5;
				}
				obj.id =  pk > 12.5 ? (pk%13) : pk;
				obj.data = img;
				myPokerArr.addItem(obj);
			}
			
			var sortA:Sort = new Sort();  
			sortA.fields=[new SortField("id")];  
			myPokerArr.sort = sortA;  
			myPokerArr.refresh(); 
			
			addPokerImg(myPokerArr);
			
			//剩余牌数
			var leftindex:int = (pokerObj.seatid+2)%3;
			var rightindex:int = (pokerObj.seatid+1)%3;
			(FlexGlobals.topLevelApplication.GameModule.child).leftgp.addElement(getHasPoker(pokerObj.pokerinfo[leftindex].count));
			(FlexGlobals.topLevelApplication.GameModule.child).rightgp.addElement(getHasPoker(pokerObj.pokerinfo[rightindex].count));
		}
		
		/**
		 * 节奏生成扑克图
		 */
		private function addPokerImg(mpa:ArrayCollection):void
		{
			var timer:Timer = new Timer(100,mpa.length);
			var pi:int = 0;
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent):void
			{
				(FlexGlobals.topLevelApplication.GameModule.child).mypoker.addElement(mpa[pi].data);
				pi++;
			});
		}
		
		/**
		 * 开始游戏界面改变
		 */
		private function starGameView():void
		{
			(FlexGlobals.topLevelApplication.GameModule.child).my_img.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).left_img.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).right_img.visible = false;
			
			(FlexGlobals.topLevelApplication.GameModule.child).gamebtn.visible = true;
			(FlexGlobals.topLevelApplication.GameModule.child).backLobbyBtn.visible = false;
		}
		
		/**
		 * 生成剩余牌数
		 */
		private function getHasPoker(num:int):HGroup
		{
			var numStr:String = num.toString();
			var hg:HGroup = new HGroup();
			hg.width = 100;
			hg.height = 30;
			hg.gap = -2;
			hg.horizontalAlign = "center";
			
			for(var i:int=0; i<numStr.length; i++){
				var img:Image = new Image();
				img.source = "assets/ddz/card_number_"+numStr.substr(i,1)+".png";
				hg.addElement(img);
			}
			
			return hg;
		}
		
		/**
		 * 点击手牌事件
		 */
		private function pokerClick(e:MouseEvent):void
		{
			var img:Image = e.currentTarget as Image;  
			var ytoNum:Number = img.y == -20 ? 0 : -20;
			var movein:Move = new Move();
			movein.target = img;
			movein.yTo =  ytoNum;
			movein.duration = 200;
			movein.yFrom = img.y;
			movein.play();
		}
		
		/**
		 * 叫地主
		 */
		private function initBank(backInfo:Object):void
		{
			var leftindex:int = (backInfo.seatid+2)%3;
			var rightindex:int = (backInfo.seatid+1)%3;
			for(var i:int=0; i<3; i++)
			{
				trace("第"+i+'号的状态:'+backInfo.callinfo[i].show);
				if(backInfo.callinfo[i].show == true)
				{
					trace("数组："+i +'叫地主');
					TimerNum = int(backInfo.times);
					//自己回合叫地主
					if(int(backInfo.seatid) == i)
					{
						if(backInfo.dmodel == false){
							initBtns(4,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
						}else{
							initBtns(2,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
						}
						newTimer(0);
					}
					//上家叫地主
					else if(leftindex == i)
					{
						newTimer(2);
					}
					//下家叫地主
					else if(rightindex == i)
					{
						newTimer(1);
					}
				}
			}
		}
		
		/**
		 * 不叫
		 */
		private function buJiaoClick(e:MouseEvent):void
		{
			var obj:Object = new Object();
			obj.protocol = SocketConst.JIAODIZHU;
			obj.points = 0;  //
			
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
		}
		
		/**
		 * 更新定时器
		 * index 定时器的位置 （0，1，2）
		 */
		private var GameTimer:Timer;
		private var TimerNum:int = 0;
		private function newTimer(index:int):void
		{
			if(TimerNum != 0){
				GameTimer = new Timer(1000,TimerNum);
				GameTimer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent):void{
					TimerNum --;
					initTimeCheck(TimerNum.toString(),index)
				});
				GameTimer.start();
			}else{
				trace("时间到..");
			}
		}
		
		/**
		 * 绘画等待时间
		 * index 时钟位置 （0，1，2  自己，右边，左边）
		 */
		private function initTimeCheck(times:String,index:int):void
		{
			var hg:HGroup = new HGroup();
			hg.width = 65;
			hg.height = 65;
			hg.gap = -3;
			hg.horizontalAlign = "center";
			hg.verticalAlign = "middle";
			
			for(var i:int=0; i<times.length; i++){
				var numimg:Image = new Image();
				numimg.source = "assets/ddz/time_number_"+times.substr(i,1)+".png";
				hg.addElement(numimg);
			}
			
			var gp:Group = new Group();
			gp.addElement(hg);
			switch(index)
			{
				case 0:
				{
					(FlexGlobals.topLevelApplication.GameModule.child).my_warp.visible = true;
					(FlexGlobals.topLevelApplication.GameModule.child).my_time.removeAllElements();
					(FlexGlobals.topLevelApplication.GameModule.child).my_time.addElement(gp);
					break;
				}
				case 1: //右边
				{
					(FlexGlobals.topLevelApplication.GameModule.child).right_warp.visible = true;
					(FlexGlobals.topLevelApplication.GameModule.child).right_time.removeAllElements();
					(FlexGlobals.topLevelApplication.GameModule.child).right_time.addElement(gp);
					break;
				}
				case 2: //左边
				{
					(FlexGlobals.topLevelApplication.GameModule.child).left_warp.visible = true;
					(FlexGlobals.topLevelApplication.GameModule.child).left_time.removeAllElements();
					(FlexGlobals.topLevelApplication.GameModule.child).left_time.addElement(gp);
					break;
				}
			}
		}
		
	}
}