package assets
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 素材加载器
	 * 2015/7/21
	 * James
	 */
	public class ImageLoader
	{
		private var loader:Loader;
		private var loaderXml:URLLoader;
		public var assetsObject:Object;
		public var assetslength:int;
		private var assestObjList:Array;
		
		public function ImageLoader()
		{
			assetsObject = new Object();
			assestObjList = new Array();
			
			loaderList("assetsList.xml");
			trace("开始加载素材包-->");
		}
		
		/**
		 * 加载外部素材包
		 * value: 远程xml地址
		 */
		public function loaderList(url:String):void
		{
			loaderXml = new URLLoader(new URLRequest(url+"?v=" + Math.floor(Math.random() * 10000)))
			loaderXml.addEventListener(Event.COMPLETE, xmlBackEvent);
			loaderXml.addEventListener(IOErrorEvent.IO_ERROR,IOError);
		}
		
		/**
		 * 素材包返回
		 * 赋值assetslength , assetsObject
		 */
		private function xmlBackEvent(event:Event):void
		{
			var xml:XML=XML(event.target.data);
			assetslength = xml.object.length();
			trace("当前加载素材包的长度为："+assetslength);
			
			for each( var x:XML in xml.object )
			{
				var obj:Object = new Object();
				obj.name = x.@assetsName;
				obj.url = x.@assetsUrl;
				assestObjList.push(obj);
			}
			loadNewImg(assetslength);
		}
		
		/**
		 * 按顺序加载远程素材
		 */
		private function loadNewImg(indx:int):void
		{
			var obj:Object = new Object();
			obj = assestObjList[indx-1];
			loaderAssets(obj.url,obj.name);
		}
		
		/**
		 * 加载外部图片/SWF
		 * value：string 外部地址
		 * 返回值：Loader对象 
		 * 图片转换bitmap = Bitmap(loader.content); 
		 */
		public function loaderAssets(url:String,name:String):void
		{
			loader = new Loader(); 
			loader.name = name;
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler); 
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadImageError);
			loader.load(new URLRequest(url)); 
		}
		
		/**
		 * 加载中事件
		 */
		private function progressHandler(e:ProgressEvent):void 
		{ 
			var progress:String = e.bytesLoaded + "/" + e.bytesTotal;
			//可加触发事件
			//trace(progress);
		} 
		
		/**
		 * 加载完成事件
		 */
		private function completeHandler(e:Event):void
		{ 
			trace("加载完成:"+loader.name);
			var bitmap:Bitmap = new Bitmap();
			bitmap = Bitmap(loader.content); 
			
			assetsObject[loader.name] = bitmap;
			assetslength --;
			if(assetslength > 0){loadNewImg(assetslength);}
			//可加触发事件
		}
		
		/**
		 * 加载素材错误事件
		 */
		private function loadImageError(event:IOErrorEvent):void
		{
			trace("ioError:" + event.text);
			assetslength --;
			if(assetslength > 0){loadNewImg(assetslength);}
			//可加触发事件
		}
		
		/**
		 * 链接ioError事件
		 */
		private function IOError(event:IOErrorEvent):void
		{
			trace("ioError:" + event.text);
		}
	}
}