package royalshield.combat
{
    import royalshield.errors.AbstractClassError;
    
    public final class MatrixOperation
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MatrixOperation()
        {
            throw new AbstractClassError(MatrixOperation);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const COPY:String = "copy";
        static public const MIRROR:String = "mirror";
        static public const FLIP:String = "flip"
        static public const ROTATE_90:String = "rotate90";
        static public const ROTATE_180:String = "rotate180";
        static public const ROTATE_270:String = "rotate270";
    }
}
