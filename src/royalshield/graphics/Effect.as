package royalshield.graphics
{
    import royalshield.core.royalshield_internal;
    import royalshield.world.Tile;
    
    use namespace royalshield_internal;
    
    public class Effect extends Graphic
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        royalshield_internal var mapIndex:int;
        royalshield_internal var tile:Tile;
        royalshield_internal var prev:Effect;
        royalshield_internal var next:Effect;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Effect(type:GraphicType)
        {
            super(type);
            
            mapIndex = -1;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function destroy():void
        {
            if (prev)
                prev.next = next;
            
            if (next)
                next.prev = prev;
            
            mapIndex = -1;
            tile = null;
            prev = null;
            next = null;
        }
    }
}
