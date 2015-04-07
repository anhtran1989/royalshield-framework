package royalshield.entities.creatures
{
    public class MonsterType
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var name:String;
        public var health:uint;
        public var healthMax:uint;
        public var experience:uint;
        public var speed:uint;
        
        public var isAttackable:Boolean;
        public var isHostile:Boolean;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function MonsterType()
        {
            this.name = "Default Monster";
            this.health = 100;
            this.healthMax = 100;
            this.experience = 0;
            this.speed = 110;
            this.isAttackable = true;
            this.isHostile = true;
        }
    }
}
