--color.lua
local _r = { }
local _g = { }
local _b = { }
local _a = { }

function loadColors ( colors )
    for col, tbl in pairs ( colors ) do
        _r[ col ] = tbl[ 1 ]
        _g[ col ] = tbl[ 2 ]
        _b[ col ] = tbl[ 3 ]
        _a[ col ] = tbl[ 4 ] or 255
    end
end

function newColor ( color, r, g, b, a )
   if not color then
      color='FastColor'
   end
   if b then   
      _r[ color ] = r
      _g[ color ] = g
      _b[ color ] = b
      _a[ color ] = a or 255
   else
      _r[ color ], _g[ color ], _b[ color ], _a[ color ] = love.graphics.getColor ( )
   end
end

function useColor ( color, alpha )
   if not color then
      color='FastColor'
   end
   if alpha~=true then
      love.graphics.setColor ( _r[ color ], _g[ color ], _b[ color ] )
   else
      love.graphics.setColor ( _r[ color ], _g[ color ], _b[ color ], _a[ color ] )
   end
end