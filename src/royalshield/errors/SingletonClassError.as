package royalshield.errors
{
    import royalshield.utils.ClassUtil;
    
    public class SingletonClassError extends Error
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function SingletonClassError(singletonClass:Class, id:uint = 0)
        {
            super("Only one instance of '" + ClassUtil.getClassName(singletonClass) + "' must be created.", id);
        }
    }
}
