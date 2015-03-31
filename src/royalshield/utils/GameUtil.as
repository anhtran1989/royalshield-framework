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
    }
}
