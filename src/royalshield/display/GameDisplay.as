package royalshield.display
{
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    
    import royalshield.core.GameConsts;
    import royalshield.core.royalshield_internal;
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.creatures.Player;
    import royalshield.entities.items.Item;
    import royalshield.geom.Position;
    import royalshield.graphics.Effect;
    import royalshield.graphics.Missile;
    import royalshield.graphics.TextualEffect;
    import royalshield.utils.CreatureStatusRenderer;
    import royalshield.utils.GameUtil;
    import royalshield.utils.RenderHelper;
    import royalshield.world.Tile;
    import royalshield.world.WorldMap;
    
    use namespace royalshield_internal;
    
    public class GameDisplay extends Sprite
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_player:Player;
        private var m_map:WorldMap;
        private var m_width:Number;
        private var m_height:Number;
        private var m_scale:Number;
        private var m_camera:Point;
        private var m_matrix:Matrix;
        private var m_canvas:GameCanvas;
        private var m_creatures:Vector.<Vector.<RenderHelper>>;
        private var m_creaturesPerTile:Vector.<uint>;
        private var m_drawnCreatures:Vector.<RenderHelper>;
        private var m_drawnCreaturesCount:uint;
        private var m_missiles:Vector.<RenderHelper>;
        private var m_missileCount:uint;
        private var m_textualEffects:Vector.<RenderHelper>;
        private var m_textualEffectCount:uint;
        private var m_statusRenderer:CreatureStatusRenderer;
        private var m_showGrid:Boolean;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get player():Player { return m_player; }
        public function set player(value:Player):void { m_player = value; }
        
        public function get map():WorldMap { return m_map; }
        public function set map(value:WorldMap):void { m_map = value; }
        
        public function get scale():Number { return m_scale; }
        public function set scale(value:Number):void
        {
            value = value < 1 ? 1 : value;
            if (m_scale != value) {
                m_scale = value;
                m_width = (GameConsts.VIEWPORT_WIDTH * m_scale);
                m_height = (GameConsts.VIEWPORT_HEIGHT * m_scale);
                m_matrix.a = (m_width / GameConsts.VIEWPORT_WIDTH);
                m_matrix.d = (m_height / GameConsts.VIEWPORT_HEIGHT);
            }
        }
        
        public function get showGrid():Boolean { return m_showGrid; }
        public function set showGrid(value:Boolean):void { m_showGrid = value; }
        
        override public function get width():Number { return m_width; }
        override public function set width(value:Number):void { /*Unused*/ }
        
        override public function get height():Number { return m_height; }
        override public function set height(value:Number):void { /*Unused*/ }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function GameDisplay()
        {
            m_camera = new Point();
            m_matrix = new Matrix();
            m_canvas = new GameCanvas(GameConsts.VIEWPORT_TOTAL_TILES_X * GameConsts.VIEWPORT_TILE_SIZE, GameConsts.VIEWPORT_TOTAL_TILES_Y * GameConsts.VIEWPORT_TILE_SIZE);
            m_statusRenderer = new CreatureStatusRenderer(GameConsts.VIEWPORT_TILES_TOTAL * 3);
            
            this.scale = 1.0;
            
            m_creatures = new Vector.<Vector.<RenderHelper>>(GameConsts.VIEWPORT_TILES_TOTAL, true);
            m_creaturesPerTile = new Vector.<uint>(GameConsts.VIEWPORT_TILES_TOTAL, true);
            
            for (var i:int = 0; i < GameConsts.VIEWPORT_TILES_TOTAL; i++) {
                m_creatures[i] = new Vector.<RenderHelper>(Tile.MAX_CREATURES, true);
                for (var k:int = 0; k < Tile.MAX_CREATURES; k++)
                    m_creatures[i][k] = new RenderHelper();
            }
            
            m_drawnCreatures = new Vector.<RenderHelper>(GameConsts.VIEWPORT_TILES_TOTAL * Tile.MAX_CREATURES, true);
            for (i = 0; i < m_drawnCreatures.length; i++)
                m_drawnCreatures[i] = new RenderHelper();
            
            m_missiles = new Vector.<RenderHelper>(MAX_MISSILES, true);
            for (i = 0; i < MAX_MISSILES; i++)
                m_missiles[i] = new RenderHelper();
            
            m_textualEffects = new Vector.<RenderHelper>(MAX_EFFECTS, true);
            for (i = 0; i < MAX_EFFECTS; i++)
                m_textualEffects[i] = new RenderHelper();
            
            this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):void
        {
            if (m_player && m_map) {
                m_camera.x = GameConsts.VIEWPORT_TILE_SIZE + m_player.walkOffsetX;
                m_camera.y = GameConsts.VIEWPORT_TILE_SIZE + m_player.walkOffsetY;
                m_matrix.tx = -m_camera.x * m_matrix.a;
                m_matrix.ty = -m_camera.y * m_matrix.d;
            }
        }
        
        public function render():void
        {
            // Lock and erase the canvas.
            m_canvas.lock();
            m_canvas.erase();
            
            m_drawnCreaturesCount = 0;
            m_missileCount = 0;
            m_textualEffectCount = 0;
            
            if (m_player && m_map) {
                findCreatures(m_map.z);
                renderTiles(m_map.z);
                drawMissiles();
            }
            
            // Unlock the canvas.
            m_canvas.unlock();
            
            // Draw the canvas in this GameDisplay.
            this.graphics.clear();
            this.graphics.beginBitmapFill(m_canvas, m_matrix, false, true);
            this.graphics.drawRect(0, 0, width, height);
            this.graphics.endFill();
            
            drawCreatureStatus();
            drawTextualEffects();
            
            if (m_showGrid)
                drawGrid(width, height);
        }
        
        public function pointToPosition(pointX:Number, pointY:Number, output:Position = null):Position
        {
            var posx:uint = 0;
            var posy:uint = 0;
            var posz:uint = 0;
            
            if (!m_player.isWorldRemoved) {
                posx = int((pointX - m_matrix.tx) / m_matrix.a / GameConsts.VIEWPORT_TILE_SIZE);
                if (posx < 1 || posx > GameConsts.VIEWPORT_VISIBLE_TILES_X)
                    return null;
                
                posy = int((pointY - m_matrix.ty) / m_matrix.d / GameConsts.VIEWPORT_TILE_SIZE);
                if (posy < 1 || posy > GameConsts.VIEWPORT_VISIBLE_TILES_Y)
                    return null;
                
                posz = m_player.tile.z;
            }
            
            posx = m_map.x + (posx - GameConsts.VIEWPORT_PLAYER_OFFSET_X);
            posy = m_map.y + (posy - GameConsts.VIEWPORT_PLAYER_OFFSET_Y);
            
            if (!output)
                return new Position(posx, posy, posz);
            
            return output.setTo(posx, posy, posz);
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function findCreatures(z:int):void
        {
            // Reset count
            for (var i:int = 0; i < GameConsts.VIEWPORT_TILES_TOTAL; i++)
                m_creaturesPerTile[i] = 0;
            
            // Find creatures in each tile on screen.
            for (var x:int = 0; x < GameConsts.VIEWPORT_TOTAL_TILES_X; x++) {
                for (var y:int = 0; y < GameConsts.VIEWPORT_TOTAL_TILES_Y; y++) {
                    var tx:uint = x + (m_map.x - GameConsts.VIEWPORT_PLAYER_OFFSET_X);
                    var ty:uint = y + (m_map.y - GameConsts.VIEWPORT_PLAYER_OFFSET_Y);
                    var tile:Tile = m_map.getTile(tx, ty, z);
                    if (!tile) continue;
                    
                    var creature:Creature = tile.firstCreature;
                    while (creature) {
                        var offsetX:int = ((x + 1) * GameConsts.VIEWPORT_TILE_SIZE + creature.walkOffsetX - creature.outfitOffsetX);
                        var offsetY:int = ((y + 1) * GameConsts.VIEWPORT_TILE_SIZE + creature.walkOffsetY - creature.outfitOffsetY);
                        var tileX:int = int((offsetX - 1) / GameConsts.VIEWPORT_TILE_SIZE);
                        var tileY:int = int((offsetY - 1) / GameConsts.VIEWPORT_TILE_SIZE);
                        var index:int = tileY * GameConsts.VIEWPORT_TOTAL_TILES_X + tileX;
                        
                        if (index >= 0 && index < GameConsts.VIEWPORT_TILES_TOTAL) {
                            var count:int = m_creaturesPerTile[index];
                            if (count >= MAX_CREATURES) 
                                break;
                            
                            m_creaturesPerTile[index] = ++count;
                            
                            var creatures:Vector.<RenderHelper> = m_creatures[index];
                            var helper:RenderHelper = creatures[(count - 1)];
                            helper.update(creature, offsetX, offsetY, x, y);
                        }
                        
                        creature = creature.next;
                    }
                }
            }
        }
        
        private function renderTiles(z:int):void
        {
            var x:int;
            var y:int;
            
            for (var i:int = 0; i < GameConsts.VIEWPORT_TILES_SUM; i++) {
                x = (GameConsts.VIEWPORT_TOTAL_TILES_X - 1);
                x = x > i ? i : x
                y = (i - GameConsts.VIEWPORT_TOTAL_TILES_X + 1);
                y = y < 0 ? 0 : y;
                
                while (x >= 0 && y < GameConsts.VIEWPORT_TOTAL_TILES_Y) {
                    renderTile(x, y, z);
                    x--;
                    y++;
                }
            }
        }
        
        private function renderTile(x:uint, y:uint, z:uint):void
        {
            var tx:uint = x + (m_map.x - GameConsts.VIEWPORT_PLAYER_OFFSET_X);
            var ty:uint = y + (m_map.y - GameConsts.VIEWPORT_PLAYER_OFFSET_Y);
            var tile:Tile = m_map.getTile(tx, ty, z);
            if (!tile) return;
            
            // ==================================================================
            // Draw items
            
            var tileOffsetX:uint = (x + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var tileOffsetY:uint = (y + 1) * GameConsts.VIEWPORT_TILE_SIZE;
            var length:uint = tile.itemCount;
            var item:Item;
            
            for (var i:int = 0; i < length; i++) {
                item = tile.getItemAt(i);
                if (item)
                    item.render(m_canvas, tileOffsetX, tileOffsetY, tx, ty, z);
            }
            
            // ==================================================================
            // Draw creatures
            
            var tileIndex:int = y * GameConsts.VIEWPORT_TOTAL_TILES_X + x;
            var creatures:Vector.<RenderHelper> = m_creatures[tileIndex];
            var count:int = m_creaturesPerTile[tileIndex];
            var index:int = 0;
            
            while (index < count) {
                var helper:RenderHelper = creatures[index];
                if (helper) {
                    var creature:Creature = helper.object as Creature;
                    if (creature)
                        creature.render(m_canvas, helper.offsetX, helper.offsetY);
                    
                    m_drawnCreatures[m_drawnCreaturesCount].setFrom(helper);
                    m_drawnCreaturesCount++;
                }
                index++;
            }
            
            // ==================================================================
            // Draw effects
            
            var halfTileSize:int = GameConsts.VIEWPORT_TILE_SIZE >> 1;
            var doubleTileSize:int = GameConsts.VIEWPORT_TILE_SIZE * 2;
            var offsetX:int = tileOffsetX;
            var offsetY:int = tileOffsetY;
            var effect:Effect = tile.firstEffect;
            var effectX:int;
            var effectY:int;
            while(effect) {
                if (effect is TextualEffect) {
                    var textualEffect:TextualEffect = TextualEffect(effect);
                    helper = m_textualEffects[m_textualEffectCount];
                    helper.update(textualEffect, (offsetX - halfTileSize) + effectX, (offsetY - GameConsts.VIEWPORT_TILE_SIZE) - 2 * effect.frame);
                    
                    if (helper.offsetY + textualEffect.height > effectY)
                        effectX += textualEffect.width;
                    
                    if (effectX < doubleTileSize) {
                        effectY = helper.offsetY;
                        m_textualEffectCount++;
                    }
                } else if (effect is Missile) {
                    if (m_missileCount < MAX_MISSILES) {
                        m_missiles[m_missileCount].update(effect, offsetX, offsetY);
                        m_missileCount++;
                    }
                } else
                    effect.render(m_canvas, offsetX, offsetY);
                
                effect = effect.next;
            }
        }
        
        private function drawCreatureStatus():void
        {
            for (var i:uint = 0; i < m_drawnCreaturesCount; i++) {
                var helper:RenderHelper = m_drawnCreatures[i];
                var creature:Creature = helper.object as Creature;
                if (creature) {
                    GameUtil.POINT.setTo(helper.offsetX - (GameConsts.VIEWPORT_TILE_SIZE * 0.5), helper.offsetY - GameConsts.VIEWPORT_TILE_SIZE);
                    m_statusRenderer.drawName(this, creature, m_matrix, GameUtil.POINT);
                }
            }
        }
        
        private function drawMissiles():void
        {
            for (var i:uint = 0; i < m_missileCount; i++) {
                var render:RenderHelper = m_missiles[i];
                var missile:Missile = Missile(render.object);
                if (missile)
                    missile.render(m_canvas, render.offsetX + missile.missileOffsetX, render.offsetY + missile.missileOffsetY);
            }
        }
        
        private function drawTextualEffects():void
        {
            var point:Point = GameUtil.POINT;
            var matrix:Matrix = GameUtil.MATRIX;
            matrix.identity();
            
            for (var i:int = 0; i < m_textualEffectCount; i++) {
                var helper:RenderHelper = m_textualEffects[i];
                var effect:TextualEffect = helper.object as TextualEffect;
                if (effect) {
                    point.x = helper.offsetX - (effect.width >> 1);
                    point.y = helper.offsetY;
                    point = m_matrix.transformPoint(point);
                    
                    if (point.x < 0)
                        point.x = 0;
                    
                    if (point.x + effect.width > width)
                        point.x = this.width - effect.width;
                    
                    if (point.y < 0)
                        point.y = 0;
                    
                    if (point.y + effect.height > this.height)
                        point.y = this.height - effect.height;
                    
                    matrix.tx = point.x;
                    matrix.ty = point.y;
                    
                    graphics.beginBitmapFill(effect.bitmap, matrix, false, false);
                    graphics.drawRect(point.x, point.y, effect.width, effect.height);
                }
            }
            
            graphics.endFill();
        }
        
        private function drawGrid(width:Number, height:Number):void
        {
            var size:Number = GameConsts.VIEWPORT_TILE_SIZE * this.scale;
            var g:Graphics = this.graphics;
            g.lineStyle(0.5, 0xFF00FF, 0.5);
            
            for (var x:int = 0; x < GameConsts.VIEWPORT_VISIBLE_TILES_X; x++) {
                for (var y:int = 0; y < GameConsts.VIEWPORT_VISIBLE_TILES_Y; y++) {
                    g.drawRect(x * size, y * size, size, size);
                }
            }
            
            g.endFill();
        }
        
        //--------------------------------------
        // Event Handlers
        //--------------------------------------
        
        protected function mouseClickHandler(event:MouseEvent):void
        {
            
        }
        
        //--------------------------------------------------------------------------
        // STATIC
        //--------------------------------------------------------------------------
        
        static public const MAX_CREATURES:uint = 10;
        static public const MAX_MISSILES:uint = 100;
        static public const MAX_EFFECTS:uint = 200;
    }
}
