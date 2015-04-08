package royalshield.world.utils
{
    import flash.geom.Point;
    
    import royalshield.core.RoyalShield;
    import royalshield.geom.Position;
    import royalshield.utils.FindPathParams;
    import royalshield.world.IWorldMap;
    
    public class FrozenPathingConditionCall
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_x:int;
        private var m_y:int;
        private var m_z:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function FrozenPathingConditionCall()
        {
            
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setTo(position:Position):FrozenPathingConditionCall
        {
            m_x = position.x;
            m_y = position.y;
            m_z = position.z;
            return this;
        }
        
        public function testPosition(startx:int, starty:int, startz:int, testx:int, testy:int, testz:int, fpp:FindPathParams, bestMatchPoint:Point):Boolean
        {
            if (!inRange(startx, starty, startz, testx, testy, testz, fpp))
                return false;
            
            var map:IWorldMap = RoyalShield.getInstance().world.map;
            if (fpp.clearSight && !map.isSightClear(testx, testy, testz, m_x, m_y, m_z, true))
                return false;
            
            var testDist:int = Math.max(Math.abs(m_x - testx), Math.abs(m_y - testy));
            
            if(fpp.maxTargetDist == 1) {
                return (testDist >= fpp.minTargetDist && testDist <= fpp.maxTargetDist);
            } else if (testDist <= fpp.maxTargetDist) {
                if(testDist < fpp.minTargetDist)
                    return false;
                
                if(testDist == fpp.maxTargetDist)
                    bestMatchPoint.x = 0;
                // not quite what we want, but the best so far.
                else if(testDist > bestMatchPoint.x)
                    bestMatchPoint.x = testDist;
                
                return true;
            }
            return false;
        }
        
        public function inRange(startx:int, starty:int, startz:int, testx:int, testy:int, testz:int, fpp:FindPathParams):Boolean
        {
            var dxMax:int = ((fpp.fullPathSearch || (startx - m_x) >= 0) ? fpp.maxTargetDist : 0);
            if(testx > (m_x + dxMax))
                return false;
            
            var dxMin:int = ((fpp.fullPathSearch || (startx - m_x) <= 0) ? fpp.maxTargetDist : 0);
            if(testx < (m_x - dxMin))
                return false;
            
            var dyMax:int = ((fpp.fullPathSearch || (starty - m_y) >= 0) ? fpp.maxTargetDist : 0);
            if(testy > (m_y + dyMax))
                return false;
            
            var dyMin:int = ((fpp.fullPathSearch || (starty - m_y) <= 0) ? fpp.maxTargetDist : 0);
            if(testy < (m_y - dyMin))
                return false;
            
            return true;
        }
    }
}
