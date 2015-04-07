package royalshield.utils
{
    import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Dictionary;
    
    import royalshield.display.GameDisplay;
    import royalshield.entities.creatures.Creature;
    
    public class CreatureStatusRenderer extends BitmapData
    {
        //--------------------------------------------------------------------------
        // PROPERTIES
        //--------------------------------------------------------------------------
        
        private var m_names:Vector.<CreatureName>;
        private var m_values:Dictionary;
        private var m_indexList:Vector.<int>;
        private var m_length:uint;
        private var m_columns:int;
        private var m_rows:int;
        private var m_width:Number;
        private var m_height:Number;
        private var m_sequence:int;
        private var m_textField:TextField;
        
        //--------------------------------------------------------------------------
        // CONSTRUCTOR
        //--------------------------------------------------------------------------
        
        public function CreatureStatusRenderer(size:uint)
        {
            m_names = new Vector.<CreatureName>();
            m_values = new Dictionary(true);
            m_width  = Math.ceil(300);
            m_height = Math.ceil(300);
            m_columns = Math.ceil(Math.sqrt(size));
            m_rows = Math.ceil(size / m_columns);
            m_indexList = new Vector.<int>(m_columns * m_rows);
            m_sequence = -100;
            m_textField = new TextField();
            m_textField.autoSize = TextFieldAutoSize.LEFT;
            m_textField.defaultTextFormat = new TextFormat("Verdana", 11, 0, true);
            m_textField.filters = [new GlowFilter(0, 1, 2, 2, 4, BitmapFilterQuality.LOW)];
            
            for (var i:uint = 0; i < m_indexList.length; i++)
                m_indexList[i] = (m_indexList.length - 1) - i;
            
            super(m_columns * m_width, m_rows * m_height, true, 0x00000000);
        }
        
        //--------------------------------------------------------------------------
        // METHODS
        //--------------------------------------------------------------------------
        
        //--------------------------------------
        // Public
        //--------------------------------------
        
        public function drawName(display:GameDisplay, creature:Creature, matrix:Matrix, point:Point):void
        {
            point = matrix.transformPoint(point);
            
            var healthColor:uint = 0x60C060;
            var rect:Rectangle = getNameRect(creature, healthColor);
            
            // ==================================================================
            // Draw name
            
            var x:Number = Math.max(1, Math.min(point.x - rect.width / 2, display.width - rect.width - 1));
            var y:Number = Math.max(0, Math.min(point.y - (rect.height + 20), display.height - (rect.height + 20)));
            
            GameUtil.MATRIX.identity();
            GameUtil.MATRIX.tx = x - rect.x;
            GameUtil.MATRIX.ty = y - rect.y;
            
            var g:Graphics = display.graphics;
            g.beginBitmapFill(this, GameUtil.MATRIX, false);
            g.drawRect(x, y, rect.width, rect.height);
            
            // ==================================================================
            // Draw health
            
            x = Math.max(1, Math.min(point.x - 14, display.width - 26));
            y += rect.height;
            
            g.beginFill(0x000000);
            g.drawRect(x, y, 27, 4);
            g.beginFill(healthColor);
            g.drawRect((x + 1), (y + 1), creature.healthPercent / 4, 2);
            g.endFill();
        }
        
        public function getNameRect(creature:Creature, color:uint):Rectangle
        {
            var value:String = String(creature.name + color);
            var name:CreatureName;
            
            if (m_values[value] != undefined)
                return CreatureName(m_values[value]).rectangle;
            
            if (m_indexList.length == 0)
            {
                name = getNameAt(0);
                delete m_values[name.value];
                
                name.value = value;
                m_values[value] = name;
                updateKey(name, m_sequence);
            }
            else
            {
                name = new CreatureName();
                name.value = value;
                name.index = m_indexList.pop();
                m_values[value] = name;
                addName(name, m_sequence);
            }
            
            var x:int = name.index % m_columns * m_width;
            var y:int = int(name.index / m_columns) * m_height;
            name.rectangle.setTo(x, y, m_width, m_height);
            fillRect(name.rectangle, 0x00000000);
            writeName(name.rectangle, creature.name, color);
            m_sequence++;
            return name.rectangle;
        }
        
        //--------------------------------------
        // Private
        //--------------------------------------
        
        private function writeName(rect:Rectangle, name:String, color:uint):void
        {
            if (rect && !isNullOrEmpty(name))
            {
                m_textField.textColor = color;
                m_textField.text = name;
                
                if (m_textField.width > m_width)
                {
                    var length:int = m_textField.getCharIndexAtPoint(m_width, m_textField.height >> 1);
                    m_textField.text = name.substr(0, length);
                }
                
                rect.width = m_textField.width;
                rect.height = m_textField.height;
                GameUtil.MATRIX.identity();
                GameUtil.MATRIX.tx = rect.x;
                GameUtil.MATRIX.ty = rect.y;
                
                draw(m_textField, GameUtil.MATRIX, null, null, null, false);
            }
        }
        
        private function addName(name:CreatureName, key:int):CreatureName
        {
            name.key = key;
            name.position = m_length;
            m_names[m_length] = name;
            m_length++;
            
            updateNameList(name.position);
            return name;
        }
        
        private function updateKey(name:CreatureName, newKey:int):void
        {
            if (name.position < m_length && name.key != newKey)
            {
                name.key = newKey;
                updateNameList(name.position);
            }
        }
        
        private function updateNameList(position:int):void
        {
            while (true)
            {
                var index:int = ((position + 1) << 1) - 1;
                var next:int = index + 1;
                var pos:int = position;
                
                if (index < m_length && m_names[index].key < m_names[pos].key)
                    pos = index;
                
                if (next < m_length && m_names[next].key < m_names[pos].key)
                    pos = next;
                
                if (pos <= position) break;
                
                m_names[position] = m_names[pos];
                m_names[position].position = position;
                m_names[pos] = m_names[position];
                m_names[pos].position = pos;
                position = pos;
            }
        }
        
        private function getNameAt(index:int):CreatureName
        {
            return index < m_length ? m_names[index] : null;
        }
    }
}

//******************************************************************************
// HELPER CLASS
//******************************************************************************

import flash.geom.Rectangle;

class CreatureName
{
    //--------------------------------------------------------------------------
    // PROPERTIES
    //--------------------------------------------------------------------------
    
    public var value:String;
    public var index:int;
    public var rectangle:Rectangle;
    public var key:int;
    public var position:int;
    
    //--------------------------------------------------------------------------
    // CONSTRUCTOR
    //--------------------------------------------------------------------------
    
    public function CreatureName()
    {
        index = -1;
        rectangle = new Rectangle();
    }
}
