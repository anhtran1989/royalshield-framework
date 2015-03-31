package royalshield.utils
{
    import flash.utils.getQualifiedClassName;
    
    import royalshield.errors.AbstractClassError;
    
    public final class ClassUtil
    {
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function ClassUtil()
        {
            throw new AbstractClassError(ClassUtil);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static function getClassName(type:Class):String
        {
            var name:String = getQualifiedClassName(type);
            var index:int = name.indexOf("::");
            if (index != -1)
                name = name.substr(index + 2);
            
            return name;
        }
    }
}
