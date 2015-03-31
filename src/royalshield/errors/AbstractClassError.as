package royalshield.errors
{
    import royalshield.utils.ClassUtil;
    
    public class AbstractClassError extends Error
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function AbstractClassError(abstractClass:Class, id:uint = 0)
        {
            super("The class '" + ClassUtil.getClassName(abstractClass) + "' cannot be instantiated.", id);
        }
    }
}
