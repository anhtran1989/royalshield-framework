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
            if (value is String && (value == "false" || value == "no" || value == "n"))
                return false;
            
            return Boolean(value);
        }
    }
}
