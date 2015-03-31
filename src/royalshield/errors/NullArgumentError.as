package royalshield.errors
{
    public class NullArgumentError extends Error
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function NullArgumentError(argumentName:String, id:uint = 0)
        {
            super("Parameter '" + argumentName + "' cannot be null.", id);
        }
    }
}
