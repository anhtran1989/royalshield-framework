package royalshield.graphics
{
    import royalshield.core.GameConsts;
    import royalshield.core.RoyalShield;
    import royalshield.geom.Direction;
    import royalshield.geom.Rect;
    
    public class Missile extends Effect
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_startX:int;
        private var m_startY:int;
        private var m_endX:int;
        private var m_endY:int;
        private var m_deltaX:int;
        private var m_deltaY:int;
        private var m_patternX:int;
        private var m_patternY:int;
        private var m_speedX:int;
        private var m_speedY:int;
        private var m_timeEnd:Number;
        private var m_duration:int;
        private var m_direction:String;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get startX():int { return m_startX; }
        public function get startY():int { return m_startY; }
        public function get endX():int { return m_endX; }
        public function get endY():int { return m_endY; }
        public function get missileOffsetX():int { return (m_deltaX + ((m_endX - m_startX) * GameConsts.VIEWPORT_TILE_SIZE)); }
        public function get missileOffsetY():int { return (m_deltaY + ((m_endY - m_startY) * GameConsts.VIEWPORT_TILE_SIZE)); }
        public function get direction():String { return m_direction; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Missile(type:GraphicType, startX:int, startY:int, endX:int, endY:int)
        {
            super(type);
            setProperties(startX, startY, endX, endY);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setProperties(startX:int, startY:int, endX:int, endY:int):void
        {
            m_startX = startX;
            m_startY = startY;
            m_endX = endX;
            m_endY = endY;
            m_deltaX = endX - startX;
            m_deltaY = endY - startY;
            m_direction = Direction.deltaToDirection(m_deltaX, m_deltaY);
            
            switch (m_direction)
            {
                case Direction.NORTH:
                    m_patternX = 1;
                    m_patternY = 0;
                    break;
                
                case Direction.EAST:
                    m_patternX = 2;
                    m_patternY = 0;
                    break;
                
                case Direction.SOUTH:
                    m_patternX = 2;
                    m_patternY = 1;
                    break;
                
                case Direction.WEST:
                    m_patternX = 2;
                    m_patternY = 2;
                    break;
                
                case Direction.SOUTHWEST:
                    m_patternX = 1;
                    m_patternY = 2;
                    break;
                
                case Direction.SOUTHEAST:
                    m_patternX = 0;
                    m_patternY = 2;
                    break;
                
                case Direction.NORTHWEST:
                    m_patternX = 0;
                    m_patternY = 1;
                    break;
                
                case Direction.NORTHEAST:
                    m_patternX = 0;
                    m_patternY = 0;
                    break;
            }
            
            m_duration = int(Math.sqrt(Math.sqrt((m_deltaX * m_deltaX) + (m_deltaY * m_deltaY))) * 150);
            m_timeEnd = RoyalShield.getElapsedTime() + m_duration;
            m_deltaX *= -GameConsts.VIEWPORT_TILE_SIZE;
            m_deltaY *= -GameConsts.VIEWPORT_TILE_SIZE;
            m_speedX = m_deltaX;
            m_speedY = m_deltaY;
        }
        
        override public function update(elapsedTime:Number):Boolean
        {
            var time:Number = elapsedTime - (m_timeEnd - m_duration);
            if (time <= 0) {
                m_deltaX = m_speedX;
                m_deltaY = m_speedY;
            } else if (time >= m_duration) {
                m_deltaX = 0;
                m_deltaY = 0;
            } else {
                m_deltaX = m_speedX - int(m_speedX / m_duration * time + 0.5);
                m_deltaY = m_speedY - int(m_speedY / m_duration * time + 0.5);
            }
            return (m_deltaX == 0 && m_deltaY == 0 || elapsedTime >= m_timeEnd);
        }
        
        override public function getTextureRect(patternX:int, patternY:int, patternZ:int, frame:int):Rect
        {
            var index:int = ((frame % m_frames * m_type.patternZ) * m_type.patternY + m_patternY) * m_type.patternX + m_patternX;
            return m_spriteSheet.rectList[index];
        }
    }
}
