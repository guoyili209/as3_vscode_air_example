package mochicrypt.util
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class DrawingMethods
   {
       
      
      public function DrawingMethods()
      {
         super();
      }
      
      public static function emptyRect(param1:Graphics, param2:Boolean, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : void
      {
         if(param2 != false)
         {
            param1.clear();
         }
         if(param7 == 0)
         {
            param7 = 1;
         }
         param1.beginFill(param8,100);
         param1.moveTo(param3,param4);
         param1.lineTo(param3 + param5,param4);
         param1.lineTo(param3 + param5,param4 + param6);
         param1.lineTo(param3,param4 + param6);
         param1.lineTo(param3,param4);
         param1.lineTo(param3 + param7,param4 + param7);
         param1.lineTo(param3 + param5 - param7,param4 + param7);
         param1.lineTo(param3 + param5 - param7,param4 + param6 - param7);
         param1.lineTo(param3 + param7,param4 + param6 - param7);
         param1.lineTo(param3 + param7,param4 + param7);
         param1.endFill();
      }
      
      public static function roundedRect(param1:Graphics, param2:Boolean, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 0, param7:String = "0", param8:Array = null, param9:Array = null, param10:Array = null, param11:Matrix = null, param12:Number = 0, param13:Number = 0, param14:Number = 1) : void
      {
         var _loc20_:Number = NaN;
         var _loc15_:Array = [];
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Number = 0;
         var _loc19_:Number = 0;
         if(param2 != false)
         {
            param1.clear();
         }
         if(param8 == null || param8.length < 1)
         {
            param8 = [0];
         }
         if(param9 == null || param9.length != param8.length)
         {
            param9 = [];
            _loc20_ = 0;
            while(_loc20_ < param8.length)
            {
               param9.push(100);
               _loc20_++;
            }
         }
         if(param10 == null || param10.length != param8.length)
         {
            param10 = [];
            _loc20_ = 0;
            while(_loc20_ < param8.length)
            {
               param10.push(_loc20_ / (param8.length - 1) * 255);
               _loc20_++;
            }
         }
         if(param7 == null || param7 == "")
         {
            param7 = "0";
         }
         _loc15_ = param7.split(" ");
         _loc16_ = parseInt(_loc15_[0]);
         _loc17_ = _loc15_[1] == undefined ? Number(_loc16_) : Number(parseInt(_loc15_[1]));
         _loc18_ = _loc15_[2] == undefined ? Number(_loc16_) : Number(parseInt(_loc15_[2]));
         _loc19_ = _loc15_[3] == undefined ? Number(_loc17_) : Number(parseInt(_loc15_[3]));
         if(param12 > 0)
         {
            if(isNaN(param14) || param14 == 0)
            {
               param14 = 1;
            }
            param1.lineStyle(param12,param13,param14);
         }
         if(param8.length == 1)
         {
            param1.beginFill(param8[0],param9[0]);
         }
         else
         {
            if(param11 == null)
            {
               (param11 = new Matrix()).createGradientBox(param5,param6,90 * (Math.PI / 180),0,0);
            }
            param1.beginGradientFill("linear",param8,param9,param10,param11);
         }
         if(_loc16_ > 0)
         {
            param1.moveTo(param3 + _loc16_,param4);
         }
         else
         {
            param1.moveTo(param3,param4);
         }
         if(_loc17_ > 0)
         {
            param1.lineTo(param3 + param5 - _loc17_,param4);
            param1.curveTo(param3 + param5,param4,param3 + param5,param4 + _loc17_);
            param1.lineTo(param3 + param5,param4 + _loc17_);
         }
         else
         {
            param1.lineTo(param3 + param5,param4);
         }
         if(_loc18_ > 0)
         {
            param1.lineTo(param3 + param5,param4 + param6 - _loc18_);
            param1.curveTo(param3 + param5,param4 + param6,param3 + param5 - _loc18_,param4 + param6);
            param1.lineTo(param3 + param5 - _loc18_,param4 + param6);
         }
         else
         {
            param1.lineTo(param3 + param5,param4 + param6);
         }
         if(_loc19_ > 0)
         {
            param1.lineTo(param3 + _loc19_,param4 + param6);
            param1.curveTo(param3,param6,param3,param4 + param6 - _loc19_);
            param1.lineTo(param3,param4 + param6 - _loc19_);
         }
         else
         {
            param1.lineTo(param3,param4 + param6);
         }
         if(_loc16_ > 0)
         {
            param1.lineTo(param3,param4 + _loc16_);
            param1.curveTo(param3,param4,param3 + _loc16_,param4);
            param1.lineTo(param3 + _loc16_,param4);
         }
         else
         {
            param1.lineTo(param3,param4);
         }
         param1.endFill();
      }
   }
}
