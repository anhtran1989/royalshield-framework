package royalshield.combat
{
    import flash.concurrent.Condition;
    
    import royalshield.conditions.ConditionType;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.creatures.Player;
    import royalshield.geom.Position;
    import royalshield.utils.BooleanUtil;
    import royalshield.utils.GameUtil;
    import royalshield.utils.MinMaxValues;
    import royalshield.world.Tile;
    
    public class Combat
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_formulaType:CombatFormulaType;
        protected var m_formulaMinA:Number;
        protected var m_formulaMinB:Number;
        protected var m_formulaMaxA:Number;
        protected var m_formulaMaxB:Number;
        
        private var m_area:AreaCombat;
        private var m_params:CombatParams;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get area():AreaCombat { return m_area; }
        public function set area(value:AreaCombat):void { m_area = value; }
        
        public function get hasArea():Boolean { return (m_area != null); }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Combat()
        {
            m_params = new CombatParams();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function setParam(param:CombatParamType, value:Object):Boolean
        {
            if (!param)
                return false;
            
            switch(param)
            {
                case CombatParamType.COMBAT_TYPE:
                    m_params.combatType = CombatType(value);
                    break;
                
                case CombatParamType.MAGIC_EFFECT:
                    m_params.magicEffect = uint(value);
                    break;
                
                case CombatParamType.MISSILE_EFFECT:
                    m_params.missileEffect = uint(value);
                    break;
                
                case CombatParamType.SOUND_EFFECT:
                    m_params.soundEffect = uint(value);
                    break;
                
                case CombatParamType.BLOCKED_BY_ARMOR:
                    m_params.blockedByArmor = BooleanUtil.toBoolean(value);
                    break;
                
                case CombatParamType.BLOCKED_BY_SHIELD:
                    m_params.blockedByShield = BooleanUtil.toBoolean(value);
                    break;
                
                case CombatParamType.TARGET_CASTER_OR_TOP_MOST:
                    m_params.targetCasterOrTopMost = BooleanUtil.toBoolean(value);
                    break;
                
                case CombatParamType.CREATE_ITEM:
                    m_params.itemId = uint(value);
                    break;
                
                case CombatParamType.AGGRESSIVE:
                    m_params.isAggressive = BooleanUtil.toBoolean(value);
                    break;
                
                case CombatParamType.DISPEL:
                    m_params.dispelType = ConditionType(value);
                    break;
                
                case CombatParamType.USE_CHARGES:
                    m_params.useCharges = BooleanUtil.toBoolean(value);
                    break;
                
                default:
                    return false;
            }
            
            return true;
        }
        
        public function setCondition(condition:Condition):void
        {
            m_params.conditions.push(condition);
        }
        
        public function setPlayerCombatValues(type:CombatFormulaType, mina:Number, minb:Number, maxa:Number, maxb:Number):void
        {
            m_formulaType = type;
            m_formulaMinA = mina;
            m_formulaMinB = minb;
            m_formulaMaxA = maxa;
            m_formulaMaxB = maxb;
        }
        
        public function doCombatByTarget(attacker:Creature, target:Creature):void
        {
            var mmv:MinMaxValues;
            if (m_params.combatType != CombatType.NONE) {
                mmv = getMinMaxValues(attacker, target, GameUtil.MAX_MIN_VALUES.setZero());
                
                if(m_params.combatType != CombatType.MANA_DRAIN)
                    doCombatHealthByTarget(attacker, target, mmv.min, mmv.max, m_params);
                else
                    doCombatManaByTarget(attacker, target, mmv.min, mmv.max, m_params);
            }
            else
                doCombatDefault(attacker, target, m_params);
        }
        
        public function doCombatByPosition(attacker:Creature, position:Position):void
        {
            var mmv:MinMaxValues;
            if (m_params.combatType != CombatType.NONE) {
                mmv = getMinMaxValues(attacker, null, GameUtil.MAX_MIN_VALUES.setZero());
                
                if (m_params.combatType != CombatType.MANA_DRAIN)
                    doCombatHealthByPosition(attacker, position, this.area, mmv.min, mmv.max, m_params);
                else
                    doCombatManaByPosition(attacker, position, area, mmv.min, mmv.max, m_params);
            }
            else
                combatFunction(attacker, position, this.area, m_params, combatNullFunction, 0);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function getMinMaxValues(creature:Creature, target:Creature, mmv:MinMaxValues):MinMaxValues
        {
            return null;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public function canTargetCreature(player:Player, target:Creature):uint
        {
            return 0;
        }
        
        static public function canDoCombat(attacker:Creature, target:Creature):uint
        {
            return 0;
        }
        
        static public function canDoCombatOnTile(attacker:Creature, tile:Tile, isAggressive:Boolean):uint
        {
            return 0;
        }
        
        static public function doCombatHealthByTarget(attacker:Creature, target:Creature, minChange:int, maxChange:int, params:CombatParams):void
        {
            //
        }
        
        static public function doCombatHealthByPosition(attacker:Creature, position:Position, area:AreaCombat, minChange:int, maxChange:int, params:CombatParams):void
        {
            //
        }
        
        static public function doCombatManaByTarget(attacker:Creature, target:Creature, minChange:int, maxChange:int, params:CombatParams):void
        {
            //
        }
        
        static public function doCombatManaByPosition(attacker:Creature, position:Position, area:AreaCombat, minChange:int, maxChange:int, params:CombatParams):void
        {
            //
        }
        
        static public function isPlayerCombat(target:Creature):Boolean
        {
            return false;
        }
        
        static public function conditionToDamageType(conditionType:ConditionType):CombatType
        {
            switch(conditionType)
            {
                case ConditionType.FIRE:
                    return CombatType.FIRE_DAMAGE;
                    
                case ConditionType.ENERGY:
                    return CombatType.ENERGY_DAMAGE;
                    
                case ConditionType.BLEEDING:
                    return CombatType.PHYSICAL_DAMAGE;
                    
                case ConditionType.DROWN:
                    return CombatType.DROWN_DAMAGE;
                    
                case ConditionType.POISON:
                    return CombatType.EARTH_DAMAGE;
                    
                case ConditionType.FREEZING:
                    return CombatType.ICE_DAMAGE;
                    
                case ConditionType.DAZZLED:
                    return CombatType.HOLY_DAMAGE;
                    
                case ConditionType.CURSED:
                    return CombatType.DEATH_DAMAGE;
                    
                default:
                    break;
            }
            
            return CombatType.NONE;
        }
        
        static public function damageToConditionType(type:CombatType):ConditionType
        {
            switch(type)
            {
                case CombatType.FIRE_DAMAGE:
                    return ConditionType.FIRE;
                    
                case CombatType.ENERGY_DAMAGE:
                    return ConditionType.ENERGY;
                    
                case CombatType.DROWN_DAMAGE:
                    return ConditionType.DROWN;
                    
                case CombatType.EARTH_DAMAGE:
                    return ConditionType.POISON;
                    
                case CombatType.ICE_DAMAGE:
                    return ConditionType.FREEZING;
                    
                case CombatType.HOLY_DAMAGE:
                    return ConditionType.DAZZLED;
                    
                case CombatType.DEATH_DAMAGE:
                    return ConditionType.CURSED;
                    
                case CombatType.PHYSICAL_DAMAGE:
                    return ConditionType.BLEEDING;
                    
                default:
                    break;
            }
            
            return ConditionType.NONE;
        }
        
        static protected function doCombatDefault(attacker:Creature, target:Creature, params:CombatParams):void
        {
            //
        }
        
        static protected function combatHealthFunction(attacker:Creature, target:Creature, params:CombatParams, change:int):Boolean
        {
            return false;
        }
        
        static protected function combatManaFunction(attacker:Creature, target:Creature, params:CombatParams, change:int):Boolean
        {
            return false;
        }
        
        static protected function combatConditionFunction(attacker:Creature, target:Creature, params:CombatParams, change:int):Boolean
        {
            return false;
        }
        
        static protected function combatDispelFunction(attacker:Creature, target:Creature, params:CombatParams,  data:*):Boolean
        {
            return false;
        }
        
        static protected function combatNullFunction(attacker:Creature, target:Creature,  params:CombatParams,  change:int):Boolean
        {
            return false;
        }
        
        static protected function combatTileEffects(list:Vector.<Creature>, attacker:Creature, tile:Tile, params:CombatParams):void
        {
            //
        }
        
        static protected function addMissile(attacker:Creature, fromPosition:Position, toPosition:Position, effectId:uint):void
        {
            //
        }
        
        static protected function combatFunction(attacker:Creature, position:Position, area:AreaCombat, params:CombatParams, callback:Function, chage:int):void
        {
            //
        }
        
        static protected function getCombatArea(centerPosition:Position, targetPosition:Position, area:AreaCombat,  list:Vector.<Tile>):void
        {
            //
        }
    }
}
