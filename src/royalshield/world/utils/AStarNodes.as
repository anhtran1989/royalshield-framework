package royalshield.world.utils
{
    import royalshield.entities.creatures.Creature;
    import royalshield.world.Tile;
    import royalshield.world.WorldMap;

    public class AStarNodes
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_nodes:Vector.<AStarNode>;
        private var m_openNodes:Vector.<Boolean>;
        private var m_currentNode:uint;
        private var m_closedNodesLength:int;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get closedNodesLength():uint { return m_closedNodesLength; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function AStarNodes()
        {
            m_nodes = new Vector.<AStarNode>(NUM_NODES, true);
            m_openNodes = new Vector.<Boolean>(NUM_NODES, true);
            m_currentNode = 0;
            m_closedNodesLength = 0;
           
            for (var i:uint = 0; i < NUM_NODES; i++)
                m_nodes[i] = new AStarNode(i);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function createOpenNode():AStarNode
        {
            if (m_currentNode >= NUM_NODES)
                return null;
            
            var current:uint = m_currentNode++;
            m_openNodes[current] = true;
            return m_nodes[current];
        }
        
        public function getBestNode():AStarNode
        {
            if (m_currentNode == 0)
                return null;
            
            var bestNode_f:int = 500;
            var bestNode:uint = 0;
            var found:Boolean = false;
            
            for (var i:uint = 0; i < m_currentNode; i++) {
                var node:AStarNode = m_nodes[i];
                if ((node.f < bestNode_f) && m_openNodes[i]) {
                    found = true;
                    bestNode_f = node.f;
                    bestNode = i;
                }
            }
            
            if (found)
                return m_nodes[bestNode];
            
            return null;
        }
        
        public function closeNode(node:AStarNode):void
        {
            var index:uint = node.index;
            if (index >= NUM_NODES) {
                CONFIG::debug { trace("AStarNodes.closeNode: trying to open node out of range.") };
                return;
            }
            
            if (m_openNodes[index]) {
                m_openNodes[index] = false;
                m_closedNodesLength++;
            }
        }
        
        public function openNode(node:AStarNode):void
        {
            var index:uint = node.index;
            if (index >= NUM_NODES) {
                CONFIG::debug { trace("AStarNodes.openNode: trying to open node out of range.") };
                return;
            }
            
            if (!m_openNodes[index]) {
                m_openNodes[index] = true;
                m_closedNodesLength--;
            }
        }
        
        public function checkInList(x:int, y:int):Boolean
        {
            return (getNode(x, y) != null)
        }
        
        public function getNode(x:int, y:int):AStarNode
        {
            for (var i:uint = 0; i < m_currentNode; i++) {
                var node:AStarNode = m_nodes[i];
                if ((node.x == x) && (node.y == y))
                    return node;
            }
            return null;
        }
        
        public function getMapWalkCost(creature:Creature, node:AStarNode, neighbourTile:Tile, x:uint, y:uint, z:uint):int
        {
            var valueX:Number = Math.abs(node.x - x);
            var valueY:Number = Math.abs(node.y - y);
            var cost:int;
            
            if (valueX == valueY)
                cost = WorldMap.DIAGONAL_WALK_COST;
            else
                cost = WorldMap.NORMAL_WALK_COST;
            
            return cost;
        }
        
        public function getTileWalkCost(creature:Creature, tile:Tile):int
        {
            return 0;
        }
        
        public function getEstimatedDistance(x1:int, y1:int, x2:int, y2:int):int
        {
            var diagonal:int = Math.min(Math.abs(x1 - x2), Math.abs(y1 - y2));
            var straight:int = (Math.abs(x1 - x2) + Math.abs(y1 - y2));
            return ((WorldMap.DIAGONAL_WALK_COST * diagonal) + WorldMap.NORMAL_WALK_COST * (straight - (2 * diagonal)));
        }
        
        public function clear():void
        {
            var length:uint = m_nodes.length;
            for (var i:uint = 0; i < length; i++) {
                var node:AStarNode = m_nodes[i];
                node.clear();
            }
            
            length = m_openNodes.length;
            for (i = 0; i < length; i++)
                m_openNodes[i] = false;
            
            m_currentNode = 0;
            m_closedNodesLength = 0;
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const NUM_NODES:uint = 200;
    }
}
