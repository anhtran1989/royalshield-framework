package royalshield.combat
{
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    public final class CombatFormulaType
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
        
        public function CombatFormulaType(type:String, index:int)
        {
            if (index >= INSTANCES)
                throw new AbstractClassError(CombatFormulaType);
            
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
        
        static private const INSTANCES:uint = 4;
        
        static public const UNDEFINED:CombatFormulaType = new CombatFormulaType("UNDEFINED", 0);
        static public const MAGIC_LEVEL:CombatFormulaType = new CombatFormulaType("MAGIC_LEVEL", 1);
        static public const SKILL:CombatFormulaType = new CombatFormulaType("SKILL", 2);
        static public const VALUE:CombatFormulaType = new CombatFormulaType("VALUE", 3);
        
        static public function toCombatFormulaType(value:Object):CombatFormulaType
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
                {
                    case 0:
                        return UNDEFINED;
                        
                    case 1:
                        return MAGIC_LEVEL;
                        
                    case 2:
                        return SKILL;
                        
                    case 3:
                        return VALUE;
                }
            } 
            else if (value is String)
            {
                var valueStr:String = value as String;
                if (isNullOrEmpty(valueStr))
                    throw new NullOrEmptyArgumentError("value");
                
                switch(StringUtil.toKeyString(valueStr))
                {
                    case "undefined":
                        return UNDEFINED;
                        
                    case "magiclevel":
                        return MAGIC_LEVEL;
                        
                    case "skill":
                        return SKILL;
                        
                    case "value":
                        return VALUE;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return UNDEFINED;
        }
    }
}
