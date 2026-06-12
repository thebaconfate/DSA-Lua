local LinkedList = require('src.linked_list')

local Stack = {}
Stack.__index = Stack


function Stack.new(top)
    return setmetatable({ top = LinkedList.new(top) }, Stack)
end

function Stack.push(value)

end
