package royalshield.world.utils
{
    public final class AStarNode
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var x:int;
        public var y:int;
        public var parent:AStarNode;
        public var f:int;
        public var g:int;
        public var h:int;
        
        internal var index:uint;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function AStarNode(index:uint)
        {
            this.index = index;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function clear():void
        {
            x = 0;
            y = 0;
            parent = null;
            f = 0;
            g = 0;
            h = 0;
        }
    }
}
