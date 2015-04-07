package royalshield.utils
{
    import royalshield.errors.AbstractClassError;
    
    public final class BooleanUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BooleanUtil()
        {
            throw new AbstractClassError(BooleanUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public function toBoolean(value:Object):Boolean
        {
            if (value is String && (value == "true" || value == "yes" || value == "y"))
                return true;
            
            return Boolean(value);
        }
    }
}
