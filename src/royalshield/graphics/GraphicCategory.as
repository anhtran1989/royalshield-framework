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
        
        public static const ITEM:String = "item";
        public static const OUTFIT:String = "outfit";
        public static const MAGIC_EFFECT:String = "magicEffect";
        public static const MISSILE:String = "missile";
    }
}
