package royalshield.world
{
    import royalshield.errors.AbstractClassError;

    public final class TileFlags
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function TileFlags()
        {
            throw new AbstractClassError(TileFlags);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const SOLID:uint = 1 << 0;
    }
}
