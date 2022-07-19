package mochicrypt
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import mochicrypt.util.ColorTools;
   import mochicrypt.util.DrawingMethods;

   public class Theme extends Sprite
   {

      private static const BAR_BACK_COLOR:int = Config.getInt("barBackColor", 16777161);

      private static const BAR_OUTLINE_COLOR:int = Config.getInt("barOutlineColor", 13994812);

      private static const BAR_FORE_COLOR:int = Config.getInt("barForeColor", 16747008);

      private static const SHOW_LOCK:Boolean = Config.getBool("showLock", true);

      private var barBackground:Shape;

      private var barForeground:Shape;

      private var progressBar:Sprite;

      private var barOutline:Shape;

      function Theme(param1:DisplayObject, param2:Number, param3:Number)
      {
         this.progressBar = new Sprite();
         this.barBackground = new Shape();
         this.barForeground = new Shape();
         this.barOutline = new Shape();
         super();
         var _loc4_:Bitmap;
         (_loc4_ = new Background()).width = param2;
         _loc4_.height = param3;
         this.setupProgressBar(param2, param3);
         addChild(_loc4_);
         addChild(param1);
         addChild(this.progressBar);
      }

      public function adLoaded(param1:Number, param2:Number):void
      {
      }

      private function setupProgressBar(param1:Number, param2:Number):void
      {
         var _loc3_:Graphics = null;
         var _loc5_:Number = NaN;
         var _loc8_:MovieClip = null;
         var _loc4_:Number = 0;
         if (SHOW_LOCK)
         {
            _loc4_ = 20;
            (_loc8_ = new LockIcon()).addFrameScript(49, _loc8_.stop);
            this.progressBar.addChild(_loc8_);
         }
         var _loc6_:Number = param1 - 20 - _loc4_;
         var _loc7_:Number = 10;
         _loc3_ = this.barBackground.graphics;
         _loc5_ = ColorTools.getRedComponent(BAR_BACK_COLOR) > ColorTools.getBlueComponent(BAR_BACK_COLOR) ? Number(6684672) : Number(51);
         DrawingMethods.roundedRect(_loc3_, true, 0, 0, _loc6_, _loc7_, "0", [ColorTools.getTintedColor(BAR_BACK_COLOR, _loc5_, 0.1), BAR_BACK_COLOR]);
         _loc3_ = this.barForeground.graphics;
         _loc5_ = ColorTools.getRedComponent(BAR_FORE_COLOR) > ColorTools.getBlueComponent(BAR_FORE_COLOR) ? Number(6684672) : Number(51);
         DrawingMethods.roundedRect(_loc3_, true, 0, 0, _loc6_, _loc7_, "0", [ColorTools.getTintedColor(BAR_FORE_COLOR, 16777215, 0.4), ColorTools.getTintedColor(BAR_FORE_COLOR, 16777215, 0.2), BAR_FORE_COLOR, ColorTools.getTintedColor(BAR_FORE_COLOR, _loc5_, 0.3)], null, [0, 120, 121, 255]);
         DrawingMethods.roundedRect(_loc3_, false, 0, 10 * 0.4, _loc6_, 1, "0", [16777215], [0.1]);
         _loc3_ = this.barOutline.graphics;
         DrawingMethods.emptyRect(_loc3_, true, 0, 0, _loc6_, _loc7_ + 1, 1, BAR_OUTLINE_COLOR);
         this.progressBar.addChild(this.barBackground);
         this.progressBar.addChild(this.barForeground);
         this.progressBar.addChild(this.barOutline);
         this.barBackground.x = this.barForeground.x = this.barOutline.x = _loc4_;
         this.barForeground.scaleX = 0;
         this.progressBar.x = 10;
         this.progressBar.y = param2 - 20;
      }

      public function updateProgress(param1:Number):void
      {
         this.barForeground.scaleX = param1;
      }
   }
}

