---@class ImmutableNode
---@field value any The data payload stored in this node
---@field next ImmutableNode|nil The pointer to the next node in the chain
local ImmutableNode = {
    value = nil,
    next = nil
}
ImmutableNode.__index = ImmutableNode

---Creates a stringified version of the value
---@return string
function ImmutableNode:toString()
    local type = type(self.value)
    if type == "nil" or
        type == "number" or
        type == "string" or
        type == "boolean" or
        type == "table" or
        type == "function" or
        type == "thread" then
        return tostring(self.value)
    else
        return self.value:toString()
    end
end

---Creates a new Node instance wrapped with the Node metatable
---@param value any
---@return ImmutableNode node The new node instance
function ImmutableNode.new(value, next)
    return setmetatable({ value = value, next = next }, ImmutableNode)
end

---@class ImmutableLinkedList
---@field private _head ImmutableNode|nil The private starting node of the linked list
local ImmutableLinkedList = { _head = nil }
ImmutableLinkedList.__index = ImmutableLinkedList

---Creates a new, empty LinkedList instance
---@param node ImmutableNode|nil (Optional) The inital head node of the list
---@return ImmutableLinkedList linkedList The new LinkedList instance
function ImmutableLinkedList.new(node)
    return setmetatable({ _head = node }, ImmutableLinkedList)
end

---Retrieves the value at the head of the list
---@return any|nil value The value at the head node, or nil if empty
function ImmutableLinkedList:head()
    return self._head and self._head.value or nil
end

---Returns a new LinkedList representing the remainder of the list after the
---head
---@return ImmutableLinkedList tail The remaining LinkedList
function ImmutableLinkedList:tail()
    if not self._head then
        error("Linked list is already the last element")
    end
    return ImmutableLinkedList.new(self._head.next)
end

---Prepends a value at the beginning of the linkedList
---@param value any A value that has to be added to the front of the linkedList
---@return ImmutableLinkedList linkedList A new linkedList with the element added at the front
function ImmutableLinkedList:prepend(value)
    local node = ImmutableNode.new(value)
    node.next = self._head
    return ImmutableLinkedList.new(node)
end

---Appends a value to the end of the linkedList
---@param value any A value that has to be added to the end of the linkedList
---@return ImmutableLinkedList linkedList A new linkedList with the element added at the back
function ImmutableLinkedList:append(value)
    if self:isEmpty() then
        return ImmutableLinkedList.new(ImmutableNode.new(value))
    else
        return self:tail():append(value):prepend(self:head())
    end
end

---Creates a linkedList from a array-like Lua table
---@param tbl table A table that has to be converted to a linkedList
---@return ImmutableLinkedList linkedList a new linkedList with the same elements and
---order of the table
function ImmutableLinkedList.fromTable(tbl)
    local list = ImmutableLinkedList.new()
    for i = #tbl, 1, -1 do
        list = list:prepend(tbl[i])
    end
    return list
end

---Returns the length of the linkedList
---@return integer length
function ImmutableLinkedList:length()
    if self:isEmpty() then
        return 0
    else
        return 1 + self:tail():length()
    end
end

---Gets the element at the nth position (counting starts at 1)
---@param index integer
---@return any value The value of the node at the nth index
function ImmutableLinkedList:nth(index)
    if index < 1 then
        error("Index must be at least 1")
    elseif self:head() == nil then
        error("Index exceeds length of linked list")
    elseif index == 1 then
        return self:head()
    else
        return self:tail():nth(index - 1)
    end
end

---Returns whether or not the linkedList is empty or not
---@return boolean isEmpty Whether the linkedList is empty
function ImmutableLinkedList:isEmpty()
    return self._head == nil
end

---Creates a stringified version of the linkedList
---@return string string Returns a string of the linkedList
function ImmutableLinkedList:toString()
    local function listToString(list)
        if list:tail():isEmpty() then
            return tostring(list:head())
        end
        return tostring(list:head()) .. ", " .. listToString(list:tail())
    end
    return "{" .. listToString(self) .. "}"
end

---Applies a function to each element of the linkedList and returns a new
---linkedList with the result of the applied function.
---@param func function A function to be applied to each node of the linkedList
---@return ImmutableLinkedList linkedList A new linkedList resulting of the function
---applied to its elements
function ImmutableLinkedList:map(func)
    if self:isEmpty() then
        return ImmutableLinkedList.new()
    else
        return self:tail():map(func):prepend(func(self:head()))
    end
end

return ImmutableLinkedList
