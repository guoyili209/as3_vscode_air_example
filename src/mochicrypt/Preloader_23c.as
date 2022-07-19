package mochicrypt
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.LocalConnection;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.filesystem.FileStream;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   
   public dynamic class Preloader_23c extends MovieClip
   {
      
      private static const AD_BACKGROUND:Boolean = Config.getBool("adBackground",false);
      
      private static const AD_URL:String = Config.getString("adURL","http://x.mochiads.com/srv/1/");
      
      private static const PATCH_URL:String = Config.getString("patchURL","http://cdn.mochiads.com/patch.swf");
      
      private static const ID:String = Config.getString("id","test");
      
      private static const PAYLOAD_NAME:String = "mochicrypt.Payload";
      
      private static const VERSION:String = "2.3c";
       
      
      private var payloadLoader:Loader;
      
      private var patchLoader:Loader;
      
      private var adDone:Boolean = false;
      
      private var theme:Theme;
      
      private var adServerControl:Boolean = false;
      
      private var adLoader:Loader;
      
      private var adDuration:int = 11000;
      
      private var payloadProgress:Number = 0.0;
      
      private var patchProgress:Number = 0.0;
      
      private var lastProgress:Number = 0.0;
      
      private var patchDisabled:Boolean = false;
      
      private var adStarted:int;
      
      private var patchDone:Boolean = false;
      
      private var payloadDone:Boolean = false;
      
      private var origFrameRate:Number = NaN;
      
      private var adComplete:Boolean = false;
      
      private var lc:LocalConnection;

            [Embed(source="../assets/binaryData/7_mochicrypt.Payload.bin",mimeType = "application/octet-stream")]
      private var payloadClass:Class;
      
      public function Preloader_23c()
      {
         this.lc = new LocalConnection();
         this.adLoader = new Loader();
         this.patchLoader = new Loader();
         this.adStarted = getTimer();
         super();
         // loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         // loaderInfo.addEventListener(Event.INIT,this.initHandler);
         // loaderInfo.addEventListener(Event.COMPLETE,this.completeHandler);
         // loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.finish();
      }
      
      private function patchProgressHandler(param1:ProgressEvent) : void
      {
         if(param1.bytesLoaded == param1.bytesTotal)
         {
            this.patchProgress = NaN;
         }
         else
         {
            this.patchProgress = Number(param1.bytesLoaded) / param1.bytesTotal;
         }
         this.progress();
      }
      
      private function adIOErrorHandler(param1:IOErrorEvent) : void
      {
         this.adDone = true;
         this.finish();
      }
      
      private function makeLCClient() : Object
      {
         var obj:Object = {};
         obj.unloadAd = function():void
         {
            trace("unloadAd");
            adDone = true;
            finish();
         };
         obj.adSkipped = function():void
         {
            trace("adSkipped");
            adDone = true;
            finish();
         };
         obj.adLoaded = function(param1:Number, param2:Number):void
         {
            trace("adLoaded called");
            theme.adLoaded(param1,param2);
         };
         obj.adjustProgress = function(param1:Number):void
         {
            trace("adjustProgress called");
            adServerControl = true;
            adStarted = getTimer();
            adDuration = param1;
         };
         obj.adjustFrameRate = this.adjustFrameRate;
         obj.disablePatch = function():void
         {
            patchDisabled = true;
         };
         return obj;
      }
      
      private function finish() : void
      {
         var i:uint = 0;
         var j:uint = 0;
         var k:uint = 0;
         var n:uint = 0;
         var u:uint = 0;
         var v:uint = 0;
         var btn:Button = null;
         // if(!this.payloadDone || !this.adDone || !this.patchDone)
         // {
         //    return;
         // }
         // if(this.payloadLoader)
         // {
         //    trace("unexpected call to finish()");
         //    return;
         // }
         // var payloadClass:Class = Class(getDefinitionByName(PAYLOAD_NAME));
         var data:ByteArray = ByteArray(new payloadClass());
         trace("data.length",data.length);
         var S:ByteArray = new ByteArray();
         n = data.length - 16;
         i = 0;
         while(i < 256)
         {
            S.writeByte(i);
            i++;
         }
         j = 0;
         i = 0;
         while(i < 256)
         {
            j = j + S[i] + data[n + (i & 15)] & 255;
            u = S[i];
            S[i] = S[j];
            S[j] = u;
            i++;
         }
         if(n > 131072)
         {
            n = 131072;
         }
         i = j = uint(0);
         k = 0;
         while(k < n)
         {
            i = i + 1 & 255;
            u = S[i];
            j = j + u & 255;
            v = S[j];
            S[i] = v;
            S[j] = u;
            data[k] ^= S[u + v & 255];
            k++;
         }
         data.uncompress();
         try
         {
            data = this.patchLoader.content["patch"](data);
         }
         catch(error:Error)
         {
            trace("patch failed",error);
         }
         var vsn:String = Capabilities.version;
         vsn = vsn.substring(vsn.indexOf(" ") + 1,vsn.indexOf(","));
         if(data[3] > parseInt(vsn))
         {
            btn = new Button();
            btn.x = (width - btn.width) / 2;
            btn.y = (height - btn.height) / 2;
            addChild(btn);
         }
         else
         {
            try
            {
               if(!isNaN(this.origFrameRate))
               {
                  stage.frameRate = this.origFrameRate;
               }
            }
            catch(error:Error)
            {
               trace("resetting frameRate failed",error);
            }
            // this.payloadLoader = new Loader();
            // addChild(this.payloadLoader);
            // this.payloadLoader.loadBytes(data);
             var fs:FileStream = new FileStream();
            var file:File = new File(File.applicationDirectory.resolvePath("game.swf").nativePath);
            fs.open(file,FileMode.WRITE);
            fs.writeBytes(data);
            fs.close();
            trace("swf complete!");
         }
         this.patchLoader.unload();
         this.adLoader.unload();
         trace("ad should be gone...");
         removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
         loaderInfo.removeEventListener(Event.INIT,this.initHandler);
         loaderInfo.removeEventListener(Event.COMPLETE,this.completeHandler);
         loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         this.patchLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.patchIOErrorHandler);
         this.patchLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.patchProgressHandler);
         this.patchLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.patchCompleteHandler);
         this.adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.adIOErrorHandler);
         this.lc.close();
         removeChild(this.theme);
         this.theme.removeChild(this.adLoader);
         this.lc = null;
         this.adLoader = null;
         this.patchLoader = null;
         this.theme = null;
      }
      
      private function enterFrameHandler(param1:Event) : void
      {
         this.progress();
         if(!this.payloadDone && currentFrame == 2)
         {
            this.payloadDone = true;
            this.finish();
         }
      }
      
      private function initHandler(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            this.origFrameRate = stage.frameRate;
         }
         catch(error:Error)
         {
            trace("can\'t access stage.frameRate in initHandler",error);
         }
         this.adjustFrameRate(30);
         var lcName:String = ["",Math.floor(new Date().getTime()),Math.floor(Math.random() * 999999)].join("_");
         this.lc.client = this.makeLCClient();
         this.lc.allowDomain("*","x.mochiads.com");
         this.lc.allowInsecureDomain("*","x.mochiads.com");
         this.lc.connect(lcName);
         this.adLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.adIOErrorHandler);
         this.adLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.adCompleteHandler);
         var lv:URLVariables = new URLVariables();
         lv.id = ID;
         lv.res = "" + loaderInfo.width + "x" + loaderInfo.height;
         lv.method = "showPreloaderAd";
         lv.swfv = loaderInfo.swfVersion;
         lv.mav = VERSION;
         lv.lc = lcName;
         lv.st = getTimer();
         lv.as3_swf = loaderInfo.loaderURL;
         lv.no_bg = !AD_BACKGROUND;
         var req:URLRequest = new URLRequest(AD_URL + ID + ".swf");
         req.contentType = "application/x-www-form-urlencoded";
         req.method = URLRequestMethod.POST;
         req.data = lv;
         this.adLoader.x = 0.5 * loaderInfo.width;
         this.adLoader.y = 0.5 * loaderInfo.height;
         try
         {
            this.adLoader.load(req);
         }
         catch(error:Error)
         {
            adDone = true;
         }
         this.patchLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.patchIOErrorHandler);
         this.patchLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.patchProgressHandler);
         this.patchLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.patchCompleteHandler);
         try
         {
            this.patchLoader.load(new URLRequest(PATCH_URL));
         }
         catch(error:Error)
         {
            patchDone = true;
         }
         this.theme = new Theme(this.adLoader,loaderInfo.width,loaderInfo.height);
         addChild(this.theme);
         // addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
         this.finish();
      }
      
      private function progressHandler(param1:ProgressEvent) : void
      {
         if(param1.bytesLoaded == param1.bytesTotal)
         {
            this.payloadProgress = NaN;
         }
         else
         {
            this.payloadProgress = Number(param1.bytesLoaded) / param1.bytesTotal;
         }
         this.progress();
      }
      
      private function adjustFrameRate(param1:Number) : void
      {
         var newFrameRate:Number = param1;
         try
         {
            if(!isNaN(this.origFrameRate))
            {
               stage.frameRate = newFrameRate;
            }
         }
         catch(error:Error)
         {
            trace("couldn\'t adjust stage.frameRate",error);
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
      }
      
      private function patchCompleteHandler(param1:Event) : void
      {
         this.patchDone = true;
         this.finish();
      }
      
      private function progress() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = 1;
         if(!this.adDone)
         {
            _loc1_ = Number(getTimer() - this.adStarted) / this.adDuration;
         }
         if(!this.payloadDone && !isNaN(this.payloadProgress) && this.payloadProgress < _loc1_)
         {
            _loc1_ = this.payloadProgress;
         }
         if(!this.patchDone && !isNaN(this.patchProgress) && this.patchProgress < _loc1_)
         {
            _loc1_ = this.patchProgress;
         }
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         if(_loc1_ > this.lastProgress)
         {
            this.lastProgress = _loc1_;
            this.theme.updateProgress(this.lastProgress);
         }
         if(!this.adServerControl && getTimer() > this.adStarted + this.adDuration)
         {
            trace("giving up... maybe?");
            if(!this.adComplete)
            {
               this.adLoader.close();
            }
            this.adDone = true;
            this.finish();
         }
      }
      
      private function patchIOErrorHandler(param1:IOErrorEvent) : void
      {
         this.patchDone = true;
         this.finish();
      }
      
      private function adCompleteHandler(param1:Event) : void
      {
         if(!this.adServerControl)
         {
            this.adStarted = getTimer();
         }
         this.adComplete = true;
         this.progress();
      }
      
      private function completeHandler(param1:Event) : void
      {
         nextFrame();
      }
   }
}

import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

class Button extends SimpleButton
{
    
   
   function Button()
   {
      super();
      var _loc1_:String = "Download the latest\nAdobe Flash Player";
      upState = new State(16777215,_loc1_);
      downState = new State(13421772,_loc1_);
      hitTestState = upState;
      overState = upState;
      addEventListener(MouseEvent.CLICK,this.buttonClicked);
      width = upState.width;
      height = upState.height;
   }
   
   public function buttonClicked(param1:Event) : void
   {
      navigateToURL(new URLRequest("http://get.adobe.com/flashplayer/"));
   }
}

import flash.display.Graphics;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

class State extends Sprite
{
    
   
   function State(param1:uint, param2:String)
   {
      super();
      var _loc3_:TextFormat = new TextFormat("Verdana");
      _loc3_.align = TextFormatAlign.CENTER;
      var _loc4_:TextField;
      (_loc4_ = new TextField()).text = param2;
      _loc4_.multiline = true;
      _loc4_.x = _loc4_.y = 2;
      _loc4_.setTextFormat(_loc3_);
      _loc4_.width = _loc4_.textWidth + 4;
      _loc4_.height = _loc4_.textHeight + 4;
      addChild(_loc4_);
      var _loc5_:Graphics;
      (_loc5_ = graphics).beginFill(param1);
      _loc5_.lineStyle(1,0);
      _loc5_.drawRoundRect(0,0,_loc4_.width + 4,_loc4_.height + 4,4);
   }
}
