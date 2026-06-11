---@class Node
---@field value any The data payload stored in this node
---@field next Node|nil The pointer to the next node in the chain
local Node = {
    value = nil,
    next = nil
}
Node.__index = Node

---Creates a stringified version of the value
---@return string
function Node:toString()
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
---@return Node node The new node instance
function Node.new(value)
    return setmetatable({ value = value, next = nil }, Node)
end

---@class LinkedList
---@field private _head Node|nil The private starting node of the linked list
local LinkedList = { _head = nil }
LinkedList.__index = LinkedList

---Creates a new, empty LinkedList instance
---@param node Node|nil (Optional) The inital head node of the list
---@return LinkedList linkedList The new LinkedList instance
function LinkedList.new(node)
    return setmetatable({ _head = node }, LinkedList)
end

---Retrieves the value at the head of the list
---@return any|nil value The value at the head node, or nil if empty
function LinkedList:head()
    return self._head and self._head.value or nil
end

---Returns a new LinkedList representing the remainder of the list after the
---head
---@return LinkedList tail The remaining LinkedList
function LinkedList:tail()
    if not self._head then
        error("Linked list is already the last element")
    end
    return LinkedList.new(self._head.next)
end

function LinkedList:prepend(value)
    local node = Node.new(value)
    node.next = self._head
    return LinkedList.new(node)
end

function LinkedList:append(value)
    if self:isEmpty() then
        return LinkedList.new(Node.new(value))
    else
        return self:tail():append(value):prepend(self:head())
    end
end

function LinkedList.fromTable(tbl)
    local list = LinkedList.new()
    for i = #tbl, 1, -1 do
        list = list:prepend(tbl[i])
    end
    return list
end

function LinkedList:length()
    if self:isEmpty() then
        return 0
    else
        return 1 + self:tail():length()
    end
end

function LinkedList:nth(index)
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

function LinkedList:isEmpty()
    return self._head == nil
end

function LinkedList:toString()
    local function listToString(list)
        if list:tail():isEmpty() then
            return tostring(list:head())
        end
        return tostring(list:head()) .. ", " .. listToString(list:tail())
    end
    return "{" .. listToString(self) .. "}"
end

---comment
---@param func function
---@return LinkedList
function LinkedList:map(func)
    if self:isEmpty() then
        return LinkedList.new()
    else
        return self:tail():map(func):prepend(func(self:head()))
    end
end

return LinkedList
