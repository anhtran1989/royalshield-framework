package royalshield.conditions
{
    import royalshield.core.royalshield_internal;
    import royalshield.errors.AbstractClassError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.utils.StringUtil;
    import royalshield.utils.isNullOrEmpty;
    
    use namespace royalshield_internal;
    
    public final class ConditionType
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
        
        public function ConditionType(type:String, index:uint)
        {
            if (index >= INSTANCES)
                throw new AbstractClassError(ConditionType);
            
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
        
        static royalshield_internal const INSTANCES:uint = 26;
        
        static public const NONE:ConditionType = new ConditionType("NONE", 0);
        static public const POISON:ConditionType = new ConditionType("POISON", 1);
        static public const FIRE:ConditionType = new ConditionType("FIRE", 2);
        static public const ENERGY:ConditionType = new ConditionType("ENERGY", 3);
        static public const BLEEDING:ConditionType = new ConditionType("BLEEDING", 4);
        static public const HASTE:ConditionType = new ConditionType("HASTE", 5);
        static public const PARALYZE:ConditionType = new ConditionType("PARALYZE", 6);
        static public const OUTFIT:ConditionType = new ConditionType("OUTFIT", 7);
        static public const INVISIBLE:ConditionType = new ConditionType("INVISIBLE", 8);
        static public const LIGHT:ConditionType = new ConditionType("LIGHT", 9);
        static public const MANA_SHIELD:ConditionType = new ConditionType("MANA_SHIELD", 10);
        static public const INFIGHT:ConditionType = new ConditionType("INFIGHT", 11);
        static public const DRUNK:ConditionType = new ConditionType("DRUNK", 12);
        static public const EXHAUST_WEAPON:ConditionType = new ConditionType("EXHAUST_WEAPON", 13);
        static public const REGENERATION:ConditionType = new ConditionType("REGENERATION", 14);
        static public const SOUL:ConditionType = new ConditionType("SOUL", 15);
        static public const DROWN:ConditionType = new ConditionType("DROWN", 16);
        static public const ATTRIBUTES:ConditionType = new ConditionType("ATTRIBUTES", 17);
        static public const FREEZING:ConditionType = new ConditionType("FREEZING", 18);
        static public const DAZZLED:ConditionType = new ConditionType("DAZZLED", 19);
        static public const CURSED:ConditionType = new ConditionType("CURSED", 20);
        static public const EXHAUST_COMBAT:ConditionType = new ConditionType("EXHAUST_COMBAT", 21);
        static public const EXHAUST_HEAL:ConditionType = new ConditionType("EXHAUST_HEAL", 22);
        static public const PACIFIED:ConditionType = new ConditionType("PACIFIED", 23);
        static public const SPELL_COOLDOWN:ConditionType = new ConditionType("SPELL_COOLDOWN", 24);
        static public const SPELL_GROUP_COOLDOWN:ConditionType = new ConditionType("SPELL_GROUP_COOLDOWN", 25);
        
        static public function toConditionType(value:*):ConditionType
        {
            if (value is int || value is uint || value is Number)
            {
                switch(int(value))
                {
                    case 0:
                        return NONE;
                        
                    case 1:
                        return POISON;
                        
                    case 2:
                        return FIRE;
                        
                    case 3:
                        return ENERGY;
                        
                    case 4:
                        return BLEEDING;
                        
                    case 5:
                        return HASTE;
                        
                    case 6:
                        return PARALYZE;
                        
                    case 7:
                        return OUTFIT;
                        
                    case 8:
                        return INVISIBLE;
                        
                    case 9:
                        return LIGHT;
                        
                    case 10:
                        return MANA_SHIELD;
                        
                    case 11:
                        return INFIGHT;
                        
                    case 12:
                        return DRUNK;
                        
                    case 13:
                        return EXHAUST_WEAPON;
                        
                    case 14:
                        return REGENERATION;
                        
                    case 15:
                        return SOUL;
                        
                    case 16:
                        return DROWN;
                        
                    case 17:
                        return ATTRIBUTES;
                        
                    case 18:
                        return FREEZING;
                        
                    case 19:
                        return DAZZLED;
                        
                    case 20:
                        return CURSED;
                        
                    case 21:
                        return EXHAUST_COMBAT;
                        
                    case 22:
                        return EXHAUST_HEAL;
                        
                    case 23:
                        return PACIFIED;
                        
                    case 24:
                        return SPELL_COOLDOWN;
                        
                    case 25:
                        return SPELL_GROUP_COOLDOWN;
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
                        
                    case "poison":
                        return POISON;
                        
                    case "fire":
                        return FIRE;
                        
                    case "energy":
                        return ENERGY;
                        
                    case "bleeding":
                        return BLEEDING;
                        
                    case "haste":
                        return HASTE;
                        
                    case "paralyze":
                        return PARALYZE;
                        
                    case "outfit":
                        return OUTFIT;
                        
                    case "invisible":
                        return INVISIBLE;
                        
                    case "light":
                        return LIGHT;
                        
                    case "manashield":
                        return MANA_SHIELD;
                        
                    case "infight":
                        return INFIGHT;
                        
                    case "drunk":
                        return DRUNK;
                        
                    case "exhaustweapon":
                        return EXHAUST_WEAPON;
                        
                    case "regeneration":
                        return REGENERATION;
                        
                    case "soul":
                        return SOUL;
                        
                    case "drown":
                        return DROWN;
                        
                    case "attributes":
                        return ATTRIBUTES;
                        
                    case "freezing":
                        return FREEZING;
                        
                    case "dazzled":
                        return DAZZLED;
                        
                    case "cursed":
                        return CURSED;
                        
                    case "exhaustcombat":
                        return EXHAUST_COMBAT;
                        
                    case "exhaustheal":
                        return EXHAUST_HEAL;
                        
                    case "pacified":
                        return PACIFIED;
                        
                    case "spellcooldown":
                        return SPELL_COOLDOWN;
                        
                    case "spellgroupcooldown":
                        return SPELL_GROUP_COOLDOWN;
                }
            }
            else
                throw new ArgumentError("Invalid argument type.");
            
            return NONE;
        }
    }
}
