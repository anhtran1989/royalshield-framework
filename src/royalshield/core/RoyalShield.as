package royalshield.core
{
    import flash.utils.getTimer;
    
    import royalshield.display.GameDisplay;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.creatures.Player;
    import royalshield.errors.NullArgumentError;
    import royalshield.errors.NullOrEmptyArgumentError;
    import royalshield.errors.SingletonClassError;
    import royalshield.geom.Position;
    import royalshield.utils.isNullOrEmpty;
    import royalshield.world.World;
    import royalshield.world.utils.AStarNodes;
    
    public class RoyalShield
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_assets:GameAssets;
        private var m_player:Player;
        private var m_world:World;
        private var m_display:GameDisplay;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get assets():GameAssets { return m_assets; }
        public function get player():Player { return m_player; }
        public function get world():World { return m_world; }
        public function get display():GameDisplay { return m_display; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function RoyalShield()
        {
            if (s_instance)
                throw new SingletonClassError(RoyalShield);
            
            s_instance = this;
            
            m_assets = new GameAssets();
            m_player = new Player();
            m_world = new World();
            m_world.onCreatureAdded.add(onCreatureAddedCallback);
            m_world.onCreatureMoved.add(onCreatureMoveCallback);
            m_display = new GameDisplay();
            m_display.player = m_player;
            m_display.map = m_world.map;
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function start():void
        {
            
        }
        
        public function update():void
        {
            var elapsedTime:Number = getTimer();
            m_world.update(elapsedTime);
            m_display.update(elapsedTime);
            m_display.render();
        }
        
        public function movePlayer(direction:String):void
        {
            if (isNullOrEmpty(direction))
                throw new NullOrEmptyArgumentError("direction");
            
            if (m_player.isWorldRemoved) {
                CONFIG::debug { trace("Game.movePlayer: The player isn't added in the world.") };
                return;
            }
            
            m_player.walkTo(direction);
        }
        
        public function moveCreatureToPosition(creature:Creature, position:Position):void
        {
            if (!creature)
                throw new NullArgumentError("creature");
            
            if (!position)
                throw new NullArgumentError("position");
            
            var directions:Vector.<String> = new Vector.<String>();
            if (m_world.map.getPathTo(creature, position, directions, AStarNodes.NUM_NODES))
                creature.startAutoWalk(directions);
        }
        
        public function getCreatureById(id:uint):Creature
        {
            return m_world.getCreatureById(id);
        }
        
        public function getCreatureByName(name:String):Creature
        {
            return m_world.getCreatureByName(name);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function onCreatureAddedCallback(creature:Creature):void
        {
            if (creature == m_player)
                m_world.map.setPosition(m_player.tile.x, m_player.tile.y, m_player.tile.z);
        }
        
        private function onCreatureMoveCallback(creature:Creature):void
        {
            if (creature == m_player)
                m_world.map.setPosition(m_player.tile.x, m_player.tile.y, m_player.tile.z);
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static private var s_instance:RoyalShield;
        static public function getInstance():RoyalShield
        {
            if (!s_instance)
                new RoyalShield();
            
            return s_instance;
        }
    }
}
