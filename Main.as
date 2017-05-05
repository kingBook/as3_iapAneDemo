package  {
	import flash.display.MovieClip;
	import flash.events.StatusEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.qywl.iap.IapAne;
	
	public class Main extends MovieClip {
		
		public function Main() {
			if(stage)init();
			else addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		private function init(e:Event=null):void{
			if(e)removeEventListener(Event.ADDED_TO_STAGE,init);
			//
			UIManager.getInstance().init(this);
			UIManager.getInstance().print("Main::init();");
			//
			initIapAne();
		}
		
		//----------------------------------------------------------------------------------------------
		private function initIapAne():void{
			var iapAne:IapAne=IapAne.getInstance();
			iapAne.logFun=UIManager.getInstance().print;//测试打印信息,可以不赋值
			iapAne.addEventListener(StatusEvent.STATUS,onStatus);
			iapAne.initialize();
			
		}
		
		private function onStatus(e:StatusEvent):void{
			UIManager.getInstance().print(e.code);
			if(e.code=="success"){
				//购买成功
			}else if(e.code=="fail"){
				//购买失败
			}
		}
		
		//点击productA按钮回调函数
		public function buyProduct(e:MouseEvent){
			UIManager.getInstance().print(e.target.name);
			if(e.target.name=="productA"){
				IapAne.getInstance().buyProduct("com.qywl.testappid.onCoin");//调用购买接口
				
			}
		}
		
		//----------------------------------------------------------------------------------------------
	}
	
}
