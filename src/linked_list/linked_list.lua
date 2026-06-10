---@class Node
---@field value any The data payload stored in this node
---@field next Node|nil The pointer to the next node in the chain
local Node = {
    value = nil,
    next = nil
}

---Creates a new Node instance wrapped with the Node metatable
---@param value any
---@return Node node The new node instance
function Node.new(value)
    return setmetatable({ value = value, next = nil }, { __index = Node })
end

---@class LinkedList
---@field private _head Node|nil The private starting node of the linked list
local LinkedList = {}
LinkedList.__index = LinkedList

---Creates a new, empty LinkedList instance
---@return LinkedList linkedList The new LinkedList instance
function LinkedList.new()
    return setmetatable({ _head = nil }, LinkedList)
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
    local _tail = LinkedList.new()
    if not self._head or not self._head.next then
        return _tail
    end
    _tail._head = self._head.next
    return _tail
end

function LinkedList:prepend(value)
    local node = Node.new(value)
    node.next = self._head
    self._head = node
    return self
end

function LinkedList:append(value)
    local new_node = Node.new(value)
    local current = self._head
    if current == nil then
        self._head = new_node
        return self
    end
    while current and current.next do
        current = current.next
    end
    current.next = new_node
    return self
end

function LinkedList.fromTable(tbl)
    local list = LinkedList.new()
    for i = #tbl, 1, -1 do
        list = list:prepend(tbl[i])
    end
    return list
end

function LinkedList:length()
    if self:head() == nil then
        return 0
    else
        return 1 + self:tail():length()
    end
end

function LinkedList:nth(index)
    if index == 1 then
        return self:head()
    elseif self:head() == nil then
        error("index exceeds length of linked list")
    else
        return self:tail():nth(index - 1)
    end
end

return LinkedList
