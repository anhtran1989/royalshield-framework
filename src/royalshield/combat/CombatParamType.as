package royalshield.combat
{
    import royalshield.core.royalshield_internal;
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    use namespace royalshield_internal;
    
    public final class CombatParamType
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
        
        public function CombatParamType(type:String, index:uint)
        {
            if (index >= INSTANCES)
                throw new AbstractClassError(CombatParamType);
            
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
        
        static royalshield_internal const INSTANCES:uint = 11;
        
        static public const COMBAT_TYPE:CombatParamType = new CombatParamType("COMBAT_TYPE", 0);
        static public const MAGIC_EFFECT:CombatParamType = new CombatParamType("MAGIC_EFFECT", 1);
        static public const MISSILE_EFFECT:CombatParamType = new CombatParamType("MISSILE_EFFECT", 2);
        static public const SOUND_EFFECT:CombatParamType = new CombatParamType("SOUND_EFFECT", 3);
        static public const BLOCKED_BY_SHIELD:CombatParamType = new CombatParamType("BLOCKED_BY_SHIELD", 4);
        static public const BLOCKED_BY_ARMOR:CombatParamType = new CombatParamType("BLOCKED_BY_ARMOR", 5);
        static public const TARGET_CASTER_OR_TOP_MOST:CombatParamType = new CombatParamType("TARGET_CASTER_OR_TOP_MOST", 6);
        static public const CREATE_ITEM:CombatParamType = new CombatParamType("CREATE_ITEM", 7);
        static public const AGGRESSIVE:CombatParamType = new CombatParamType("AGGRESSIVE", 8);
        static public const DISPEL:CombatParamType = new CombatParamType("DISPEL", 9);
        static public const USE_CHARGES:CombatParamType = new CombatParamType("USE_CHARGES", 10);
        
        static public function toCombatParamType(value:Object):CombatParamType
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
                {
                    case 0:
                        return COMBAT_TYPE;
                        
                    case 1:
                        return MAGIC_EFFECT;
                        
                    case 2:
                        return MISSILE_EFFECT;
                        
                    case 3:
                        return SOUND_EFFECT;
                        
                    case 4:
                        return BLOCKED_BY_SHIELD;
                        
                    case 5:
                        return BLOCKED_BY_ARMOR;
                        
                    case 6:
                        return TARGET_CASTER_OR_TOP_MOST;
                        
                    case 7:
                        return CREATE_ITEM;
                        
                    case 8:
                        return AGGRESSIVE;
                        
                    case 9:
                        return DISPEL;
                        
                    case 10:
                        return USE_CHARGES;
                }
            } 
            else if (value is String)
            {
                var valueStr:String = value as String;
                if (isNullOrEmpty(valueStr))
                    throw new NullOrEmptyArgumentError("value");
                
                switch(StringUtil.toKeyString(valueStr))
                {
                    case "combattype":
                        return COMBAT_TYPE;
                        
                    case "magiceffect":
                        return MAGIC_EFFECT;
                        
                    case "missileeffect":
                        return MISSILE_EFFECT;
                        
                    case "soundeffect":
                        return SOUND_EFFECT;
                        
                    case "blockedbyshield":
                        return BLOCKED_BY_SHIELD;
                        
                    case "blockedbyarmor":
                        return BLOCKED_BY_ARMOR;
                        
                    case "targetcasterortopmost":
                        return TARGET_CASTER_OR_TOP_MOST;
                        
                    case "createitem":
                        return CREATE_ITEM;
                        
                    case "aggressive":
                        return AGGRESSIVE;
                        
                    case "dispel":
                        return DISPEL;
                        
                    case "usecharges":
                        return USE_CHARGES;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return null;
        }
    }
}
