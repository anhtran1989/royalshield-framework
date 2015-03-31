package royalshield.utils
{
    import royalshield.errors.AbstractClassError;

    public final class GameUtils
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameUtils()
        {
            throw new AbstractClassError(GameUtils);
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
