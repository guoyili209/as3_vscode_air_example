package mochicrypt
{
   public class Config
   {
      [Embed(source="../assets/6_mochicrypt.ConfigData.bin",mimeType = "application/octet-stream")]
      private static var configData:Class;
      public static const data:Object=new configData().readObject();
       
      
      function Config()
      {
         super();
      }
      
      public static function getBool(param1:String, param2:Boolean) : Boolean
      {
         return data[param1] is Boolean ? Boolean(data[param1]) : Boolean(param2);
      }
      
      public static function getInt(param1:String, param2:int) : int
      {
         return data[param1] is int ? int(data[param1]) : int(param2);
      }
      
      public static function getString(param1:String, param2:String) : String
      {
         return data[param1] is String ? data[param1] : param2;
      }
   }
}
