package com.qywl.iap{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class IapAne extends EventDispatcher{
		public static const EXTENSION_ID:String = "com.qywl.IapAne";//需要与extension.xml中的id一样
		private static var _instance:IapAne;
		private var _extensionContext:ExtensionContext;
		private var _isInited:Boolean;
		public var logFun:Function;
		
		public static function getInstance():IapAne{
			return _instance||=new IapAne();
		}
		
		public function IapAne(){
			_extensionContext=ExtensionContext.createExtensionContext(EXTENSION_ID,null);
			if(_extensionContext) _extensionContext.addEventListener(StatusEvent.STATUS,onStatus);
			else throw new Error("===创建ExtensionContext出错,请检查extension ID是否正确");
		}
		
		private function onStatus(e:StatusEvent):void{
			dispatchEvent(e);
			if(logFun!=null)logFun("===onStatus e.code:",e.code);
		}
		
		public function initialize():void{
			if(_isInited)return;
			_isInited=true;
			_extensionContext.call("initialize");
			if(logFun!=null)logFun("===call ios initialize();");
		}
		
		public function buyProduct(productID:String):void{
			_extensionContext.call("buyProduct",productID);
			if(logFun!=null)logFun("===call ios buyProduct();");
		}
		
		/*public function setTesting(value:Boolean):void{
			_extensionContext.call("setTesting",value);
			if(logFun!=null)logFun("===call ios setTesting();");
		}*/
		
		
	};
	
}