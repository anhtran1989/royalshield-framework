package royalshield.combat
{
    import royalshield.core.royalshield_internal;
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    use namespace royalshield_internal;
    
    public final class BlockHitType
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_type:String;
        private var m_index:uint;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get type():String { return m_type; }
        public function get index():uint { return m_index; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function BlockHitType(type:String, index:uint)
        {
            if (index >= INSTANCES)
                throw new AbstractClassError(BlockHitType);
            
            m_type = type;
            m_index = index;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function toString():String
        {
            return m_type;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static royalshield_internal const INSTANCES:uint = 4;
        
        static public const NONE:BlockHitType = new BlockHitType("NONE", 0);
        static public const DEFENSE:BlockHitType = new BlockHitType("DEFENSE", 1);
        static public const ARMOR:BlockHitType = new BlockHitType("ARMOR", 2);
        static public const IMMUNITY:BlockHitType = new BlockHitType("IMMUNITY", 3);
        
        static public function toBlockHitType(value:Object):BlockHitType
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
                {
                    case 0:
                        return NONE;
                        
                    case 1:
                        return DEFENSE;
                        
                    case 2:
                        return ARMOR;
                        
                    case 3:
                        return IMMUNITY;
                }
            } 
            else if (value is String)
            {
                var valueStr:String = value as String;
                if (isNullOrEmpty(valueStr))
                    throw new NullOrEmptyArgumentError("value");
                
                switch(StringUtil.toKeyString(valueStr))
                {
                    case "none":
                        return NONE;
                        
                    case "defense":
                        return DEFENSE;
                        
                    case "armor":
                        return ARMOR;
                        
                    case "immunity":
                        return IMMUNITY;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return NONE;
        }
    }
}

