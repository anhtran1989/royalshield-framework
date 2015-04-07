package royalshield.combat
{
    import royalshield.conditions.Condition;
    import royalshield.conditions.ConditionType;
    
    public class CombatParams
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var combatType:CombatType;
        public var dispelType:ConditionType;
        public var itemId:uint;
        public var magicEffect:uint;
        public var missileEffect:uint;
        public var soundEffect:uint;
        public var blockedByArmor:Boolean;
        public var blockedByShield:Boolean;
        public var targetCasterOrTopMost:Boolean;
        public var isAggressive:Boolean;
        public var useCharges:Boolean;
        public var conditions:Vector.<Condition>;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function CombatParams()
        {
            this.combatType = CombatType.NONE;
            this.dispelType = ConditionType.NONE;
            this.conditions = new Vector.<Condition>();
        }
    }
}
