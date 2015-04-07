package royalshield.combat
{
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    public final class CombatType
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
        
        public function CombatType(type:String, index:uint)
        {
            s_count++;
            if (s_count > 13)
                throw new AbstractClassError(CombatType);
            
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
        
        static private var s_count:uint = 0;
        
        static public const NONE:CombatType = new CombatType("NONE", 0);
        static public const PHYSICAL_DAMAGE:CombatType = new CombatType("PHYSICAL_DAMAGE", 1);
        static public const ENERGY_DAMAGE:CombatType = new CombatType("ENERGY_DAMAGE", 2);
        static public const EARTH_DAMAGE:CombatType = new CombatType("EARTH_DAMAGE", 3);
        static public const FIRE_DAMAGE:CombatType = new CombatType("FIRE_DAMAGE", 4);
        static public const UNDEFINED_DAMAGE:CombatType = new CombatType("UNDEFINED_DAMAGE", 5);
        static public const LIFE_DRAIN:CombatType = new CombatType("LIFE_DRAIN", 6);
        static public const MANA_DRAIN:CombatType = new CombatType("MANA_DRAIN", 7);
        static public const HEALING:CombatType = new CombatType("HEALING", 8);
        static public const DROWN_DAMAGE:CombatType = new CombatType("DROWN_DAMAGE", 9);
        static public const ICE_DAMAGE:CombatType = new CombatType("ICE_DAMAGE", 10);
        static public const HOLY_DAMAGE:CombatType = new CombatType("HOLY_DAMAGE", 11);
        static public const DEATH_DAMAGE:CombatType = new CombatType("DEATH_DAMAGE", 12);
        
        static public function toCombatType(value:*):CombatType
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
                {
                    case 0:
                        return NONE;
                        
                    case 1:
                        return PHYSICAL_DAMAGE;
                        
                    case 2:
                        return ENERGY_DAMAGE;
                        
                    case 3:
                        return EARTH_DAMAGE;
                        
                    case 4:
                        return FIRE_DAMAGE;
                        
                    case 5:
                        return UNDEFINED_DAMAGE;
                        
                    case 6:
                        return LIFE_DRAIN;
                        
                    case 7:
                        return MANA_DRAIN;
                        
                    case 8:
                        return HEALING;
                        
                    case 9:
                        return DROWN_DAMAGE;
                        
                    case 10:
                        return ICE_DAMAGE;
                        
                    case 11:
                        return HOLY_DAMAGE;
                        
                    case 12:
                        return DEATH_DAMAGE;
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
                        
                    case "physicaldamage":
                        return PHYSICAL_DAMAGE;
                        
                    case "energydamage":
                        return ENERGY_DAMAGE;
                        
                    case "earthdamage":
                        return EARTH_DAMAGE;
                        
                    case "firedamage":
                        return FIRE_DAMAGE;
                        
                    case "undefineddamage":
                        return UNDEFINED_DAMAGE;
                        
                    case "lifedrain":
                        return LIFE_DRAIN;
                        
                    case "manadrain":
                        return MANA_DRAIN;
                        
                    case "healing":
                        return HEALING;
                        
                    case "drowndamage":
                        return DROWN_DAMAGE;
                        
                    case "icedamage":
                        return ICE_DAMAGE;
                        
                    case "holydamage":
                        return HOLY_DAMAGE;
                        
                    case "deathdamage":
                        return DEATH_DAMAGE;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return NONE;
        }
    }
}
