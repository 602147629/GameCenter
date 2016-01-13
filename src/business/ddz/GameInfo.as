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
		private var GS:GameSupport = new GameSupport();
		private var banker:int  //地主
		private var myCards:int //我的牌数
		private var selectPoker:ArrayCollection;  //选中牌组
		private var pokerImg:Array = new Array(assets.poker0,assets.poker1,assets.poker2,assets.poker3,assets.poker4,assets.poker5,assets.poker6,assets.poker7,assets.poker8,assets.poker9,assets.poker10,assets.poker11,assets.poker12,assets.poker13,assets.poker14,assets.poker15,assets.poker16,assets.poker17,assets.poker18,assets.poker19,assets.poker20,assets.poker21,assets.poker22,assets.poker23,assets.poker24,assets.poker25,assets.poker26,assets.poker27,assets.poker28,assets.poker29,assets.poker30,assets.poker31,assets.poker32,assets.poker33,assets.poker34,assets.poker35,assets.poker36,assets.poker37,assets.poker38,assets.poker39,assets.poker40,assets.poker41,assets.poker42,assets.poker43,assets.poker44,assets.poker45,assets.poker46,assets.poker47,assets.poker48,assets.poker49,assets.poker50,assets.poker51,assets.poker52,assets.poker53);
		private var upPokerArr:Array;//牌弹起数组name
		
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
					initMyPoker(dataReust.data[0]);
					break;
				case SocketConst.CALLBANK: // 叫地主
					trace("叫地主");
					initBank(dataReust.data[0]);
					break;
				case SocketConst.POKERINFO: // 主底牌确认,初始化底牌
					trace("地主底牌确认");
					FlexGlobals.topLevelApplication.tableInfo.DATA = dataReust.data;
					FlexGlobals.topLevelApplication.tableInfo.PROTOCOL = dataReust.protocol;
					initBoss(dataReust.data[0]);
					break;
				case SocketConst.YOURTURN: // 出牌推送
					trace("出牌推送");
					yourTurn(dataReust.data);
					break;
				case SocketConst.OUTCARDSUSSFOR: // 出牌成功
					outCardSuss(dataReust.data);
					break;
				default:
				{
					trace("未知协议号！");
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
			if(type != -1)
			{
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
					case 3:
					{
						//绘画出牌，不出,提示按钮
						var btn5:Image = new Image();
						btn5.buttonMode = true;
						btn5.source = assets.btn_dont;
						btn5.name = '0';
						btn5.addEventListener(MouseEvent.CLICK,outCardEvent);
						
						var btn6:Image = new Image();
						btn6.buttonMode = true;
						btn6.source = assets.btn_outCard;
						btn6.name = '1';
						btn6.addEventListener(MouseEvent.CLICK,outCardEvent);
						
						var btn7:Image = new Image();
						btn7.buttonMode = true;
						btn7.source = assets.btn_prompt;
						
						myg.addElement(btn5);
						myg.addElement(btn6);
						myg.addElement(btn7);
						break;
					}
					case 4:
					{
						//绘画1/2/3 分  不抢按钮
						var btn8:Image = new Image();
						btn8.buttonMode = true;
						btn8.source = assets.btn_one;
						btn8.name = '1';
						btn8.addEventListener(MouseEvent.CLICK,callBankClick);
						
						var btn9:Image = new Image();
						btn9.buttonMode = true;
						btn9.source = assets.btn_two;
						btn9.name = '2';
						btn9.addEventListener(MouseEvent.CLICK,callBankClick);
						
						var btn10:Image = new Image();
						btn10.buttonMode = true;
						btn10.source = assets.btn_three;
						btn10.name = '3';
						btn10.addEventListener(MouseEvent.CLICK,callBankClick);
						
						var btn11:Image = new Image();
						btn11.buttonMode = true;
						btn11.source = assets.btn_dun_call;
						btn11.name = '0';
						btn11.addEventListener(MouseEvent.CLICK,callBankClick);
						
						myg.addElement(btn8);
						myg.addElement(btn9);
						myg.addElement(btn10);
						myg.addElement(btn11);
						break;
					}
					case 5:
					{
						//绘画出牌,提示按钮
						var btn12:Image = new Image();
						btn12.buttonMode = true;
						btn12.source = assets.btn_outCard;
						btn12.name = '1';
						btn12.addEventListener(MouseEvent.CLICK,outCardEvent);
						
						var btn13:Image = new Image();
						btn13.buttonMode = true;
						btn13.source = assets.btn_prompt;
						
						myg.addElement(btn12);
						myg.addElement(btn13);
						break;
					}
				}
				myg.addEventListener(Event.ADDED_TO_STAGE,fadein);
				myg.addEventListener(Event.REMOVED_FROM_STAGE,fadeout);
			}
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
		public function initMyPoker(pokerObj:Object):void
		{
			GS.starGameView();   //开始游戏界面
			selectPoker = new ArrayCollection();
			var  mySeat:int = pokerObj.seatid;
			
			makeMyPoker(pokerObj.seatinfo[mySeat].pokers);
			
			GS.reashPokernum(pokerObj.seatid,pokerObj.seatinfo);
		}

		/**
		 * 添加牌
		 */
		public function makeMyPoker(parr:Array,effect:Boolean=true):void
		{
			var myPokerArr:ArrayCollection = new ArrayCollection();
			myPokerArr = mackCardOnTable(parr);
			(FlexGlobals.topLevelApplication.GameModule.child).mypoker.removeAllElements();
			GS.addPokerImg(myPokerArr,effect);
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
			cleanTable();
			var leftindex:int = (backInfo.seatid+2)%3;
			var rightindex:int = (backInfo.seatid+1)%3;
			for(var i:int=0; i<3; i++)
			{
				if(backInfo.seatinfo[i].called == true)
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
						break;
					}
					//上家叫地主
					if(leftindex == i)
					{
						newTimer(2);
						break;
					}
					//下家叫地主
					if(rightindex == i)
					{
						newTimer(1);
						break;
					}
				}
			}
		}
		
		/**
		 * 清理桌面
		 */
		private function cleanTable():void
		{
			trace('清理桌面');
			TimerNum = 0;
			if(GameTimer != null){GameTimer.reset();}
			(FlexGlobals.topLevelApplication.GameModule.child).mybtns.removeAllElements();
			(FlexGlobals.topLevelApplication.GameModule.child).my_warp.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).my_time.removeAllElements();
			(FlexGlobals.topLevelApplication.GameModule.child).right_warp.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).right_time.removeAllElements();
			(FlexGlobals.topLevelApplication.GameModule.child).left_warp.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).left_time.removeAllElements();
		}
		
		/**
		 * 叫分事件
		 */
		private function callBankClick(e:MouseEvent):void
		{
			var callStr:String = (e.currentTarget as Image).name;
			
			var obj:Object = new Object();
			obj.protocol = SocketConst.JIAODIZHU;
			obj.points = callStr;  //
			
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
			
			GameTimer.reset();
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
				if(GameTimer != null){GameTimer.reset()};
				GameTimer = new Timer(1000,TimerNum);
				GameTimer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent):void{
					TimerNum --;
					GS.initTimeCheck(TimerNum.toString(),index)
				});
				GameTimer.start();
			}else{
				trace("时间到..");
			}
		}
		
		/**
		 * 确认地主，底牌
		 */
		private function initBoss(pokerInfo:Object):void
		{
			banker = pokerInfo.banker;
			var leftindex:int = (pokerInfo.seatid+2)%3;
			var rightindex:int = (pokerInfo.seatid+1)%3;
			
			if(banker == pokerInfo.seatid)
			{
				makeMyPoker(pokerInfo.seatinfo[pokerInfo.seatid].pokers,false);  //给自己加牌
				initBtns(-1,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
			}else
			{
				//剩余牌数
				GS.reashPokernum(pokerInfo.seatid,pokerInfo.seatinfo);
			}
			
			GS.setBanker(pokerInfo);
			var warp_:Group = (FlexGlobals.topLevelApplication.GameModule.child).warp;
			for (var i:int=0; i<3; i++) 	
			{
				var cardIndex:int = pokerInfo.pokers[i];
				trace("底牌："+cardIndex);
				(warp_.getChildByName("top_"+i) as Image).source = pokerImg[cardIndex];
			}
			
			changeMultiple(pokerInfo.multiple);
		}
		
		/**
		 * 改变倍数
		 */
		private function changeMultiple(m:int):void
		{
			(FlexGlobals.topLevelApplication.GameModule.child).beishu.text = m.toString();
		}
		
		/**
		 * 出牌推送
		 */
		private function yourTurn(resultData:Object):void
		{
			var leftindex:int = (resultData.seatid+2)%3;
			var rightindex:int = (resultData.seatid+1)%3;
			
			if(resultData.first == true){
				(FlexGlobals.topLevelApplication.GameModule.child).my_card.removeAllElements();
				(FlexGlobals.topLevelApplication.GameModule.child).outher_card.removeAllElements();
			}
			
			for(var i:int=0; i<3; i++)
			{
				if(resultData.seatinfo[i].show == true)
				{
					TimerNum = int(resultData.seatinfo[i].times);
					if(int(resultData.seatid) == i)
					{
						if(resultData.first == false){
							initBtns(3,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
						}else{
							initBtns(5,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
						}
						myCards = resultData.seatinfo[i].count;
						newTimer(0);
						break;
					}
					//上家
					if(leftindex == i)
					{
						newTimer(2);
						break;
					}
					//下家
					if(rightindex == i)
					{
						newTimer(1);
						break;
					}
				}
			}
		}
		
		/**
		 * 出牌事件
		 * name 0 不出
		 */
		private function outCardEvent(e:MouseEvent):void
		{
			var type:String = (e.currentTarget as Image).name;
			
			var obj:Object = new Object();
			obj.protocol = SocketConst.OUTCARD;
			if(type == '0')
			{
				obj.count = '0'; 
				obj.poker = '-1';
			}
			else if(type == '1'){
				var cardArr:Array = GS.getSelectCard(myCards);
				obj.count = cardArr.length;  
				obj.poker = String(cardArr);  
			}
			eventModel = new EventModel(EventModel.WRITESOCKET,false,false,obj);
			EventModel.dis.dispatchEvent(eventModel);
			GameTimer.reset();
		}
		
		/**
		 * 出牌成功
		 */
		private function outCardSuss(resultData:Object):void
		{
			cleanTable();
			initBtns(-1,(FlexGlobals.topLevelApplication.GameModule.child).mybtns);
			
			var leftindex:int = (resultData.seatid+2)%3;
			var rightindex:int = (resultData.seatid+1)%3;
			var poker:ArrayCollection = mackCardOnTable(resultData.poker,false);
			
			if(poker != null){
				(FlexGlobals.topLevelApplication.GameModule.child).outher_card.removeAllElements();
				var hg:HGroup = new HGroup();
				hg.gap = -50;
				for each (var p:Object in poker) 
				{
					hg.addElement(p.data);
				}
			}
			
			for(var i:int=0; i<3; i++)
			{
				if(resultData.showinfo[i].show == true)
				{
					if(int(resultData.seatid) == i && poker != null)
					{
						(FlexGlobals.topLevelApplication.GameModule.child).my_card.addElement(hg);
						GS.delectPoker(resultData.poker);
						break;
					}else if(int(resultData.seatid) != i && poker != null)
					{
						(FlexGlobals.topLevelApplication.GameModule.child).outher_card.addElement(hg);
						(FlexGlobals.topLevelApplication.GameModule.child).my_card.removeAllElements();
					}
					//上家
					if(leftindex == i && poker != null)
					{
						(FlexGlobals.topLevelApplication.GameModule.child).outher_card.horizontalAlign = 'left';
						break;
					}
					//下家
					if(rightindex == i && poker != null)
					{
						(FlexGlobals.topLevelApplication.GameModule.child).outher_card.horizontalAlign = 'right';
						break;
					}
				}
			}
			//刷新剩余牌数
			GS.reashPokernum(resultData.seatid,resultData.seatinfo);
		}
		
		/**
		 * 生成桌面上的牌
		 */
		private var isdown:Boolean = false;
		public function mackCardOnTable(poker:Array,effect:Boolean=true):ArrayCollection
		{
			if(poker[0] != -1){
				var myPokerArr:ArrayCollection = new ArrayCollection();
				for each(var pk:int in poker)
				{
					var img:Image = new Image();
					img.source = pokerImg[pk];
					img.name = pk.toString();
					if(effect == true)
					{
						img.addEventListener(MouseEvent.CLICK,pokerClick);
						img.addEventListener(MouseEvent.MOUSE_OVER,pokerOver);
						img.addEventListener(MouseEvent.MOUSE_UP,function (e:MouseEvent):void{
							isdown = false;
							tools.clearColor((FlexGlobals.topLevelApplication.GameModule.child).mypoker);
						});
						img.addEventListener(MouseEvent.MOUSE_DOWN,function (e:MouseEvent):void{isdown = true;});
					};
					
					var obj:Object = new Object();
					if(pk != 52 && pk != 53){
						obj.id =  pk > 12.5 ? (pk%13) : pk;
					}else{
						obj.id = pk;
					}
					obj.data = img;
					myPokerArr.addItem(obj);
				}
				var sortA:Sort = new Sort();  
				sortA.fields=[new SortField("id")];  
				myPokerArr.sort = sortA;  
				myPokerArr.refresh(); 
				
				return myPokerArr;
			}else{return null;}
		}
		
		/**
		 * 多选牌组
		 */
		private function pokerOver(e:MouseEvent):void
		{
			var img:Image = e.currentTarget as Image;
			if(isdown == true)
			{
				var ytoNum:Number = img.y == -20 ? 0 : -20;
				var movein:Move = new Move();
				movein.target = img;
				movein.yTo =  ytoNum;
				movein.duration = 200;
				movein.yFrom = img.y;
				movein.play();
				if(img.filters.length==0)
					tools.setColor(img);
			}
		}
		
	}
}