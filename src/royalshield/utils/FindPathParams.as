package royalshield.utils
{
    public class FindPathParams
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var fullPathSearch:Boolean;
        public var clearSight:Boolean;
        public var allowDiagonal:Boolean;
        public var keepDistance:Boolean;
        public var maxSearchDist:int;
        public var minTargetDist:int;
        public var maxTargetDist:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function FindPathParams()
        {
            identity();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function identity():void
        {
            this.fullPathSearch = true;
            this.clearSight = true;
            this.allowDiagonal = true;
            this.keepDistance = false;
            this.maxSearchDist = -1;
            this.minTargetDist = -1;
            this.maxTargetDist = -1;
        }
    }
}
