package mochicrypt.util
{
   public class ColorTools
   {
       
      
      public function ColorTools()
      {
         super();
      }
      
      public static function getGreenComponent(param1:uint) : uint
      {
         return param1 >> 8 & 255;
      }
      
      public static function getRedComponent(param1:uint) : uint
      {
         return param1 >> 16;
      }
      
      public static function getBlueOffset(param1:uint, param2:Number) : Number
      {
         var _loc3_:uint = getBlueComponent(param1);
         return _loc3_ * param2;
      }
      
      public static function getGreenOffset(param1:uint, param2:Number) : Number
      {
         var _loc3_:uint = getGreenComponent(param1);
         return _loc3_ * param2;
      }
      
      public static function getTintedColor(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:uint = getRedComponent(param1);
         var _loc5_:uint = getGreenComponent(param1);
         var _loc6_:uint = getBlueComponent(param1);
         var _loc7_:uint = getRedComponent(param2);
         var _loc8_:uint = getGreenComponent(param2);
         var _loc9_:uint = getBlueComponent(param2);
         return _loc4_ + (_loc7_ - _loc4_) * param3 << 16 | _loc5_ + (_loc8_ - _loc5_) * param3 << 8 | _loc6_ + (_loc9_ - _loc6_) * param3;
      }
      
      public static function getBlueComponent(param1:uint) : uint
      {
         return param1 & 255;
      }
      
      public static function getRedOffset(param1:uint, param2:Number) : Number
      {
         var _loc3_:uint = getRedComponent(param1);
         return _loc3_ * param2;
      }
   }
}
