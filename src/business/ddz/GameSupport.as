package business.ddz
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;

	public class GameSupport
	{
		private var assets:Object = FlexGlobals.topLevelApplication.assetsObject;
		
		/**
		 * 绘画等待时间
		 * index 时钟位置 （0，1，2  自己，右边，左边）
		 */
		public function initTimeCheck(times:String,index:int):void
		{
			var hg:HGroup = new HGroup();
			hg.width = 60;
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
		
		/**
		 * 节奏生成扑克图
		 */
		public function addPokerImg(mpa:ArrayCollection,effect:Boolean):void
		{
			if(effect==true)
			{
				(FlexGlobals.topLevelApplication.GameModule.child).mybtns.enabled = false;
				var timer:Timer = new Timer(100,mpa.length);
				var pi:int = 0;
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent):void
				{
					(FlexGlobals.topLevelApplication.GameModule.child).mypoker.addElement(mpa[pi].data);
					pi++;
					if(pi == mpa.length){
						(FlexGlobals.topLevelApplication.GameModule.child).mybtns.enabled = true;
					}
				});
			}else{
				for(var i:int=0; i<mpa.length; i++)
				{
					(FlexGlobals.topLevelApplication.GameModule.child).mypoker.addElement(mpa[i].data);
				}
			}
		}
		
		/**
		 * 开始游戏界面改变
		 */
		public function starGameView():void
		{
			(FlexGlobals.topLevelApplication.GameModule.child).my_img.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).left_img.visible = false;
			(FlexGlobals.topLevelApplication.GameModule.child).right_img.visible = false;
			
			(FlexGlobals.topLevelApplication.GameModule.child).gamebtn.visible = true;
			(FlexGlobals.topLevelApplication.GameModule.child).backLobbyBtn.visible = false;
		}
		
		/**
		 * 改变地主界面
		 */
		public function setBanker(PI:Object):void
		{
			var leftindex:int = (PI.seatid+2)%3;
			var rightindex:int = (PI.seatid+1)%3;

			switch(PI.banker)
			{
				case PI.seatid:
				{
					//自己是地主
					(FlexGlobals.topLevelApplication.GameModule.child).P_my.source = assets.landlord_face;
					break;
				}
				case leftindex:
				{
					(FlexGlobals.topLevelApplication.GameModule.child).P_left.source = assets.landlord_face;
					break;
				}
				case rightindex:
				{
					(FlexGlobals.topLevelApplication.GameModule.child).P_right.source = assets.landlord_face;
					break;
				}
			}
		}
		
		/**
		 * 获取选中牌组
		 */
		public function getSelectCard(cards:int):Array
		{
			var cardArr:Array = new Array();
			var myHG:HGroup = (FlexGlobals.topLevelApplication.GameModule.child).mypoker;
			
			for(var i:int=0; i<cards; i++){
				if((myHG.getChildAt(i) as Image).y == -20)
				{
					cardArr.push((myHG.getChildAt(i) as Image).name);
				}
			}
			return cardArr;
		}
		
		/**
		 * 更新剩余牌数
		 */
		public function reashPokernum(seatid:int,poker:Array):void
		{
			var leftindex:int = (seatid+2)%3;
			var rightindex:int = (seatid+1)%3;
			(FlexGlobals.topLevelApplication.GameModule.child).leftgp.removeAllElements();
			(FlexGlobals.topLevelApplication.GameModule.child).rightgp.removeAllElements();
			(FlexGlobals.topLevelApplication.GameModule.child).leftgp.addElement(getHasPoker(poker[leftindex].count));
			(FlexGlobals.topLevelApplication.GameModule.child).rightgp.addElement(getHasPoker(poker[rightindex].count));
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
		 * 清理手牌
		 */
		public function delectPoker(cards:Array):void
		{
			var myHG:HGroup = (FlexGlobals.topLevelApplication.GameModule.child).mypoker;
			for each (var names:int in cards) 
			{
				var img:Image = myHG.getChildByName(names.toString()) as Image;
				myHG.removeElement(img);
			}
		}
		
		
	}
}