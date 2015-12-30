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
				var timer:Timer = new Timer(100,mpa.length);
				var pi:int = 0;
				timer.start();
				timer.addEventListener(TimerEvent.TIMER,function (e:TimerEvent):void
				{
					(FlexGlobals.topLevelApplication.GameModule.child).mypoker.addElement(mpa[pi].data);
					pi++;
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
		
	}
}