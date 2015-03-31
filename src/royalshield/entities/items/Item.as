package royalshield.entities.items
{
    import royalshield.display.GameCanvas;
    import royalshield.entities.GameObject;
    import royalshield.graphics.Graphic;
    import royalshield.graphics.IRenderable;
    import royalshield.graphics.IUpdatable;
    import royalshield.utils.IDestroyable;
    
    public class Item extends GameObject implements IUpdatable, IRenderable, IDestroyable
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        public var isSolid:Boolean;
        
        protected var m_graphic:Graphic;
        protected var m_isAnimated:Boolean;
        
        //--------------------------------------
        // Getters / Setters 
        //--------------------------------------
        
        public function get graphic():Graphic { return m_graphic; }
        public function set graphic(value:Graphic):void
        { 
            if (m_graphic != value) {
                m_graphic = value;
                m_isAnimated = m_graphic ? m_graphic.isAnimated : false;
            }
        }
        
        public function get isAnimated():Boolean { return m_isAnimated; }
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function Item(id:uint, name:String)
        {
            super(id, name);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function update(elapsedTime:Number):Boolean
        {
            if (m_graphic)
                return m_graphic.update(elapsedTime);
            
            return false;
        }
        
        public function render(canvas:GameCanvas, pointX:int, pointY:int, patternX:int = 0, patternY:int = 0, patternZ:int = 0):void
        {
            if (m_graphic)
                m_graphic.render(canvas, pointX, pointY, patternX, patternY, patternZ);
        }
        
        public function destroy():void
        {
            m_graphic = null;
        }
    }
}
