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
        
        public static const COPY:String = "copy";
        public static const MIRROR:String = "mirror";
        public static const FLIP:String = "flip"
        public static const ROTATE_90:String = "rotate90";
        public static const ROTATE_180:String = "rotate180";
        public static const ROTATE_270:String = "rotate270";
    }
}
