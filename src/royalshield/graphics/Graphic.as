package royalshield.graphics
{
    import royalshield.animators.Animator;
    import royalshield.display.GameCanvas;
    import royalshield.entities.GameObject;
    import royalshield.errors.NullArgumentError;
    import royalshield.geom.Rect;
    import royalshield.textures.SpriteSheet;
    
    public class Graphic extends GameObject implements IGraphic
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        protected var m_type:GraphicType;
        protected var m_frames:uint;
        protected var m_frame:uint;
        protected var m_offsetX:uint;
        protected var m_offsetY:uint;
        protected var m_spriteSheet:SpriteSheet;
        protected var m_animator:Animator;
        
        private var m_isAnimated:Boolean;
        
        //--------------------------------------
        // Getters / Setters
        //--------------------------------------
        
        public function get type():GraphicType { return m_type; }
        public function get frames():uint { return m_frames; }
        
        public function get frame():uint { return m_frame; }
        public function set frame(value:uint):void { m_frame = value; }
        
        public function get offsetX():uint { return m_offsetX; }
        public function get offsetY():uint { return m_offsetY; }
        
        public function get isAnimated():Boolean { return m_isAnimated; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Graphic(type:GraphicType)
        {
            super(null, type.id);
            setGraphicType(type);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):Boolean
        {
            if (m_animator) {
                m_animator.update(elapsedTime);
                m_frame = m_animator.currentFrame;
            }
            return false;
        }
        
        public function render(canvas:GameCanvas, pointX:int, pointY:int, patternX:int = 0, patternY:int = 0, patternZ:int = 0):void
        {
            if (m_spriteSheet) {
                var rect:Rect = getTextureRect(patternX, patternY, patternZ, m_frame);
                var px:int = pointX - rect.width - m_offsetX;
                var py:int = pointY - rect.height - m_offsetY;
                canvas.render(m_spriteSheet, rect.x, rect.y, rect.width, rect.height, px, py);
            }
        }
        
        public function getTextureRect(patternX:int, patternY:int, patternZ:int, frame:int):Rect
        {
            patternX %= m_type.patternX;
            patternY %= m_type.patternY;
            patternZ %= m_type.patternZ;
            frame %= m_type.frames;
            
            var index:int = m_type.getTextureIndex(0, patternX, patternY, patternZ, frame);
            return m_spriteSheet.rectList[index];
        }
        
        public function destroy():void
        {
            //
        }
        
        //--------------------------------------
        // Internal
        //--------------------------------------
        
        internal function setGraphicType(type:GraphicType):void
        {
            if (!type)
                throw new NullArgumentError("type");
            
            m_type = type;
            m_frames = type.frames;
            m_spriteSheet = type.spriteSheet;
            m_animator = type.animator ? type.animator.clone() : null;
            m_isAnimated = m_animator ? m_animator.frameCount > 1 : false;
            m_offsetX = type.offsetX;
            m_offsetY = type.offsetY;
        }
    }
}
