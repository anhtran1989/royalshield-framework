package royalshield.utils
{
    import royalshield.errors.AbstractClassError;

    public final class GameUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameUtil()
        {
            throw new AbstractClassError(GameUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static function getPercentValue(value:int, max:int):uint
        {
            return max < 0 ? 0 : uint(Math.ceil(value * 100 / max));
        }
        
        public static function hash(str:String):uint
        {
            var fnvPrime:uint=  0x811C9DC5;
            var hash:uint = 0;
            for (var i:int = 0; i < str.length; i++) {
                hash *=fnvPrime;
                hash ^= uint(str.charCodeAt(i));
            }
            return hash;
        }
    }
}
