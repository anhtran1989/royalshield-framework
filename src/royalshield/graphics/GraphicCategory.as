package royalshield.graphics
{
    import royalshield.errors.AbstractClassError;
    
    public final class GraphicCategory
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GraphicCategory()
        {
            throw new AbstractClassError(GraphicCategory);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const ITEM:String = "item";
        static public const OUTFIT:String = "outfit";
        static public const MAGIC_EFFECT:String = "magicEffect";
        static public const MISSILE:String = "missile";
    }
}
