package royalshield.errors
{
    public class NullOrEmptyArgumentError extends Error
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function NullOrEmptyArgumentError(argumentName:String, id:uint = 0)
        {
            super("Parameter '" + argumentName + "' cannot be null or empty.", id);
        }
    }
}
