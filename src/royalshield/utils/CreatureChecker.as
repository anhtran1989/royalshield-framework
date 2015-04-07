package royalshield.utils
{
    import royalshield.core.royalshield_internal;
    import royalshield.entities.creatures.Creature;
    import royalshield.graphics.IUpdatable;
    
    use namespace royalshield_internal;
    
    public class CreatureChecker implements IUpdatable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_creatures:Vector.<Vector.<Creature>>;
        private var m_toAdd:Vector.<Creature>;
        private var m_toRemove:Vector.<Creature>;
        private var m_nextTime:Number;
        private var m_currentList:int;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function CreatureChecker()
        {
            m_creatures = new Vector.<Vector.<Creature>>(VECTOR_COUNT, true);
            m_toAdd = new Vector.<Creature>();
            m_toRemove = new Vector.<Creature>();
            m_nextTime = 0;
            
            for (var i:int = 0; i < VECTOR_COUNT; i++)
                m_creatures[i] = new Vector.<Creature>();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):Boolean
        {
            if (elapsedTime >= m_nextTime) {
                check();
                m_nextTime = elapsedTime + THINK_INTERVAL;
            }
            return true;
        }
        
        public function addCreature(creature:Creature):void
        {
            if (!creature.worldRemoved && creature.checkerIndex == -1) {
                m_toAdd[m_toAdd.length] = creature;
                creature.checkerIndex = int(Math.random() * VECTOR_COUNT);
            }
        }
        
        public function removeCreature(creature:Creature):void
        {
            creature.checkerIndex = -1;
        }
        
        public function clear():void
        {
            m_toAdd.length = 0;
            m_toRemove.length = 0;
            m_nextTime = 0;
            
            for (var i:int = 0; i < VECTOR_COUNT; i++) {
                var list:Vector.<Creature> = m_creatures[i];
                var length:uint = list.length;
                if (length > 0) {
                    for (var k:int = 0; k < length; k++)
                        list[k].checkerIndex = -1;
                    
                    list.length = 0;
                }
            }
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function check():void
        {
            var list:Vector.<Creature>;
            var length:uint;
            var i:int;
            var creature:Creature;
            
            // Add creatures
            length = m_toAdd.length;
            if (length > 0) {
                for (i = 0; i < length; i++) {
                    creature = m_toAdd[i];
                    list = m_creatures[creature.checkerIndex];
                    list[list.length] = creature;
                }
                
                m_toAdd.length = 0;
            }
            
            // Check creatures
            list = m_creatures[m_currentList];
            length = list.length;
            for (i = 0; i < length; i++) {
                creature = list[i];
                if (creature.checkerIndex != -1) {
                    if (creature.health > 0)
                        creature.onThink(CHECK_INTERVAL);
                    else
                        creature.onDeath();
                } else
                    m_toRemove[m_toRemove.length] = creature;
            }
            
            // Remove creatures
            length = m_toRemove.length;
            if (length > 0) {
                for (i = 0; i < length; i++) {
                    var index:int = list.indexOf(m_toRemove[i]);
                    if (index >= 0)
                        list.splice(index, 1); 
                }
                m_toRemove.length = 0;
            }
            
            m_currentList++;
            if (m_currentList >= VECTOR_COUNT)
                m_currentList = 0;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private const VECTOR_COUNT:uint = 2;
        static private const CHECK_INTERVAL:uint = 1000;
        static private const THINK_INTERVAL:uint = CHECK_INTERVAL / VECTOR_COUNT;
    }
}
