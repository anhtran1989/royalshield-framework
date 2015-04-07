package royalshield.utils
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import royalshield.entities.creatures.Creature;
    import royalshield.errors.AbstractClassError;
    import royalshield.geom.Position;
    
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
        
        static public const ZERO_POINT:Point = new Point();
        static public const POINT:Point = new Point();
        static public const RECTANGLE:Rectangle = new Rectangle();
        static public const MATRIX:Matrix = new Matrix();
        static public const POSITION:Position = new Position();
        static public const MAX_MIN_VALUES:MinMaxValues = new MinMaxValues();
        static public const CREATURE_VECTOR:Vector.<Creature> = new Vector.<Creature>();
        
        static public function getPercentValue(value:int, max:int):uint
        {
            return max < 0 ? 0 : uint(Math.ceil(value * 100 / max));
        }
        
        static public function hash(str:String):uint
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
