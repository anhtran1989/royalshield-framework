package royalshield.geom
{
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    public final class Direction
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        internal var m_type:String;
        internal var m_index:uint;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        public function get index():uint { return m_index; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Direction(type:String, index:uint)
        {
            s_count++;
            if (s_count > 8)
                throw new AbstractClassError(Direction);
            
            m_type = type;
            m_index = index;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return m_type;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private var s_count:uint = 0;
        
        static public const NORTH:Direction = new Direction("NORTH", 0);
        static public const EAST:Direction = new Direction("EAST", 1);
        static public const SOUTH:Direction = new Direction("SOUTH", 2);
        static public const WEST:Direction = new Direction("WEST", 3);
        static public const SOUTHWEST:Direction = new Direction("SOUTHWEST", 4);
        static public const SOUTHEAST:Direction = new Direction("SOUTHEAST", 5);
        static public const NORTHWEST:Direction = new Direction("NORTHWEST", 6);
        static public const NORTHEAST:Direction = new Direction("NORTHEAST", 7);
        
        static public function toDirection(value:Object):Direction
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
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
            }
            else if (value is String)
            {
                var valueStr:String = value as String;
                if (isNullOrEmpty(valueStr))
                    throw new NullOrEmptyArgumentError("value");
                
                switch(StringUtil.toKeyString(valueStr))
                {
                    case "north":
                        return NORTH;
                        
                    case "east":
                        return EAST;
                        
                    case "south":
                        return SOUTH;
                        
                    case "west":
                        return WEST;
                        
                    case "southwest":
                        return SOUTHWEST;
                        
                    case "southeast":
                        return SOUTHEAST;
                        
                    case "northwest":
                        return NORTHWEST;
                        
                    case "northeast":
                        return NORTHEAST;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return NORTH;
        }
        
        static public function deltaToDirection(deltaX:int, deltaY:int):Direction
        {
            const radiusA:int = 106;
            const radiusB:int = 256;
            const radiusC:int = 618;
            var direction:Direction;
            
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
