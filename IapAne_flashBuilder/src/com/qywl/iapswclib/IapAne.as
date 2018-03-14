package com.qywl.iapswclib{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	/**
	 * ...
	 * @author kingBook
	 * 2017/4/18 12:03
	 */
	public class IapAne extends EventDispatcher{
		public static const EXTENSION_ID:String = "com.qywl.IapAne";
		private static var _instance:IapAne;
		private var _extensionContext:ExtensionContext;
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
			logFun("===onStatus e.code:",e.code);
		}
		
		public function initialize():void{
			_extensionContext.call("initialize");
			logFun("===call ios initialize");
		}
		
		
	};
	
}