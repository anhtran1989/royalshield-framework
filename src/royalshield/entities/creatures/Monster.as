package royalshield.entities.creatures
{
    import royalshield.core.royalshield_internal;
    import royalshield.errors.NullArgumentError;
    import royalshield.utils.GameUtil;
    
    use namespace royalshield_internal;
    
    public class Monster extends Creature
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_monsterType:MonsterType;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Monster(type:MonsterType)
        {
            super();
            setMonsterType(type);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Override Public
        //--------------------------------------
        
        override public function toString():String
        {
            return "[Monster name=" + this.name + ", id=" + this.id + "]";
        }
        
        //--------------------------------------
        // Internal
        //--------------------------------------
        
        royalshield_internal function setMonsterType(type:MonsterType):void
        {
            if (!type)
                throw new NullArgumentError("type");
            
            m_monsterType = type;
            m_name = type.name;
            m_health = type.health;
            m_healthMax = type.healthMax;
            m_heathPercent = GameUtil.getPercentValue(m_health, m_healthMax);
        }
    }
}
