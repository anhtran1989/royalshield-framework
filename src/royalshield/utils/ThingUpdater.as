package royalshield.utils
{
    import flash.utils.Dictionary;
    
    import royalshield.entities.GameObject;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.items.Item;
    import royalshield.graphics.IUpdatable;
    
    public class ThingUpdater implements IUpdatable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_items:Dictionary;
        private var m_toAddItems:Vector.<Item>;
        private var m_toRemoveItems:Vector.<Item>;
        private var m_itemsCount:uint;
        private var m_creatures:Dictionary;
        private var m_toAddCreatures:Vector.<Creature>;
        private var m_toRemoveCreatures:Vector.<Creature>;
        private var m_creaturesCount:uint;
        private var m_nextUpdateTime:Number;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get creaturesCount():uint { return m_creaturesCount; }
        public function get itemsCount():uint { return m_itemsCount; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function ThingUpdater()
        {
            createCheckLists();
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):Boolean
        {
            if (elapsedTime >= m_nextUpdateTime) {
                for each (var creature:Creature in m_creatures)
                    creature.update(elapsedTime);
                
                for each (var item:Item in m_items)
                    item.update(elapsedTime);
                
                clanup();
                m_nextUpdateTime = elapsedTime + UPDATE_INTERVAL;
            }
            return true;
        }
        
        public function addGameObject(obj:GameObject):Boolean
        {
            if (obj is Creature)
                m_toAddCreatures[m_toAddCreatures.length] = Creature(obj);
            else if (obj is Item)
                m_toAddItems[m_toAddItems.length] = Item(obj);
            else
                return false;
            
            return true;
        }
        
        public function removeGameObject(obj:GameObject):Boolean
        {
            if (obj is Creature)
                m_toRemoveCreatures[m_toRemoveCreatures.length] = Creature(obj);
            else if (obj is Item)
                m_toRemoveItems[m_toRemoveItems.length] = Item(obj);
            else
                return false;
            
            return true;
        }
        
        public function clear():void
        {
            createCheckLists();
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function createCheckLists():void
        {
            m_items = new Dictionary();
            m_toAddItems = new Vector.<Item>();
            m_toRemoveItems = new Vector.<Item>();
            m_creatures = new Dictionary();
            m_toAddCreatures = new Vector.<Creature>();
            m_toRemoveCreatures = new Vector.<Creature>();
            m_creaturesCount = 0;
            m_itemsCount = 0;
            m_nextUpdateTime = 0;
        }
        
        private function addCreature(creature:Creature):void
        {
            if (m_creatures[creature.id] === undefined) {
                m_creatures[creature.id] = creature;
                m_creaturesCount++;
            }
        }
        
        private function removeCreature(creature:Creature):void
        {
            if (m_creatures[creature.id] !== undefined) {
                delete m_creatures[creature.id];
                m_creaturesCount--;
            }
        }
        
        private function addItem(item:Item):void
        {
            if (m_items[item] === undefined) {
                m_items[item] = item;
                m_itemsCount++;
            }
        }
        
        private function removeItem(item:Item):void
        {
            if (m_items[item] !== undefined) {
                delete m_items[item];
                m_itemsCount--;
            }
        }
        
        private function clanup():void
        {
            var i:int;
            
            // ==================================================================
            // Adiciona as criaturas pendentes.
            
            var length:uint = m_toAddCreatures.length;
            if (length > 0) {
                for (i = 0; i < length; i++)
                    addCreature(m_toAddCreatures[i]);
                
                m_toAddCreatures.length = 0;
            }
            
            // ==================================================================
            // Remove criaturas pendentes.
            
            length = m_toRemoveCreatures.length;
            if (length > 0) {
                for (i = 0; i < length; i++)
                    removeCreature(m_toRemoveCreatures[i]);
                
                m_toRemoveCreatures.length = 0;
            }
            
            // ==================================================================
            // Adiciona itens pendentes.
            
            length = m_toAddItems.length;
            if (length > 0) {
                for (i = 0; i < length; i++)
                    addItem(m_toAddItems[i]);
                
                m_toAddItems.length = 0;
            }
            
            // ==================================================================
            // Remove itens pendentes.
            
            length = m_toRemoveItems.length;
            if (length > 0) {
                for (i = 0; i < length; i++)
                    removeItem(m_toRemoveItems[i]);
                
                m_toRemoveItems.length = 0;
            }
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        public static const UPDATE_INTERVAL:uint = 40;
    }
}
