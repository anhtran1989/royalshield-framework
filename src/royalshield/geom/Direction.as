package royalshield.geom
{
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.isNullOrEmpty;

    public final class Direction
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Direction(type:String, value:uint)
        {
            throw new AbstractClassError(Direction);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const NORTH:String = "NORTH";
        public static const EAST:String = "EAST";
        public static const SOUTH:String = "SOUTH";
        public static const WEST:String = "WEST";
        public static const SOUTHWEST:String = "SOUTHWEST";
        public static const SOUTHEAST:String = "SOUTHEAST";
        public static const NORTHWEST:String = "NORTHWEST";
        public static const NORTHEAST:String = "NORTHEAST";
        
        public static function directionToValue(direction:String):uint
        {
            if (isNullOrEmpty(direction))
                throw new NullOrEmptyArgumentError("value");
            
            switch(String(direction).toUpperCase())
            {
                case NORTH:
                    return 0;
                    
                case EAST:
                    return 1;
                    
                case SOUTH:
                    return 2;
                    
                case WEST:
                    return 3;
                    
                case SOUTHWEST:
                    return 4;
                    
                case SOUTHEAST:
                    return 5;
                    
                case NORTHWEST:
                    return 6;
                    
                case NORTHEAST:
                    return 7;
            }
            
            throw new Error("Direction.toDirection: Unknown Direction '{0}'.", direction);
        }
        
        public static function valueToDirection(value:uint):String
        {
            switch(value)
            {
                case 0:
                    return NORTH;
                    
                case 1:
                    return EAST;
                    
                case 2:
                    return SOUTH;
                    
                case 3:
                    return WEST;
                    
                case 4:
                    return SOUTHWEST;
                    
                case 5:
                    return SOUTHEAST;
                    
                case 6:
                    return NORTHWEST;
                    
                case 7:
                    return NORTHEAST;
            }
            
            throw new Error("Direction.toDirection: Unknown Direction value '{0}'.", value);
        }
        
        public static function deltaToDirection(deltaX:int, deltaY:int):String
        {
            const radiusA:int = 106;
            const radiusB:int = 256;
            const radiusC:int = 618;
            var direction:String;
            
            if (deltaX == 0) {
                if (deltaY <= 0)
                    direction = Direction.NORTH;
                else
                    direction = Direction.SOUTHWEST;
            } else if (deltaX > 0) {
                if (radiusB * deltaY > radiusC * deltaX)
                    direction = Direction.SOUTHWEST;
                else if (radiusB * deltaY > radiusA * deltaX)
                    direction = Direction.WEST;
                else if (radiusB * deltaY > -radiusA * deltaX)
                    direction = Direction.SOUTH;
                else if (radiusB * deltaY > -radiusC * deltaX)
                    direction = Direction.EAST;
                else
                    direction = Direction.NORTH;
            } else if (-radiusB * deltaY < radiusC * deltaX)
                direction = Direction.SOUTHWEST;
            else if (-radiusB * deltaY < radiusA * deltaX)
                direction = Direction.SOUTHEAST;
            else if (-radiusB * deltaY < -radiusA * deltaX)
                direction = Direction.NORTHWEST;
            else if (-radiusB * deltaY < -radiusC * deltaX)
                direction = Direction.NORTHEAST;
            else
                direction = Direction.NORTH;
            
            return direction;
        }
    }
}
