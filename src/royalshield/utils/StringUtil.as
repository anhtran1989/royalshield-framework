package royalshield.utils
{
    import royalshield.errors.AbstractClassError;
    
    public final class StringUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function StringUtil()
        {
            throw new AbstractClassError(StringUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private const CHARS:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        static private const HEX_CHARS:String = "ABCDEF0123456789";
        
        static public function randomKeyString(length:uint = 8, hex:Boolean = false):String
        {
            var chars:String = hex ? HEX_CHARS : CHARS;
            var numChars:uint = chars.length - 1;
            var randomChar:String = "";
            
            for (var i:uint = 0; i < length; i++)
                randomChar += chars.charAt(Math.floor(Math.random() * numChars));
            
            return randomChar;
        }
        
        static public function toKeyString(value:String):String
        {
            return removeWhitespaces(value.toLowerCase()).replace(/_/g, "");
        }
        
        static public function removeWhitespaces(str:String):String
        {
            return str == null ? null : str.replace(/\s/g, "");
        }
        
        static public function format(str:String, ... rest):String
        {
            if (str == null)
                return "";
            
            var length:uint = rest.length;
            for (var i:uint = 0; i < length; i++)
                str = str.replace(new RegExp("\\{" + i + "\\}", "g"), rest[i]);
            
            return str;
        }
        
        static public function capitaliseFirstLetter(text:String):String
        {
            if (!isNullOrEmpty(text))
                return text.substring(0, 1).toUpperCase() + text.substr(1, text.length - 1);
            
            return text;
        }
    }
}
