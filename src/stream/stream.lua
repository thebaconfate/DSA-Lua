local LazyNode = {}
LazyNode.__index = LazyNode

function LazyNode.new(value, generator)
    return setmetatable({
        value = value,
        _next_thunk = generator,
        _cached_next = nil
    }, LazyNode)
end

function LazyNode:next()
    if not self._cached_next and self._next_thunk then
        local next_value = self._next_thunk()
        if next_value ~= nil then
            self._cached_next = LazyNode.new(next_value, self._next_thunk)
        end
    end
    return self._cached_next
end

local Stream = {}
Stream.__index = Stream

function Stream.new(node)
    return setmetatable({ _head = node }, Stream)
end

function Stream:isEmpty()
    return self._head == nil
end

function Stream:head()
    if type(self._head) == "function" then
        self._head = self._head()
    end
    return self._head.value
end

function Stream:tail()
    if self:isEmpty() then
        error("Stream is already the last element")
    else
        return Stream.new(function()
            return self._head:next()
        end)
    end
end

function Stream:prepend(value)
    if self:isEmpty() then
        return Stream.new(LazyNode.new(value, function() return nil end))
    else
        return Stream.new(LazyNode.new(
            value,
            function()
                if type(self._head) == "function" then
                    self._head = self._head()
                end
                return self._head.value
            end
        ))
    end
end

local s1 = Stream.new()
local s2 = s1:prepend(1)
local s3 = s2:prepend(2)
print(s1:isEmpty())
print(s2:isEmpty())
print(s3:head())
print(s3:tail():head())

return Stream
