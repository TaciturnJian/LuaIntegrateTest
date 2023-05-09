--- 存放一些Sango写的杂七杂八的方法，经过了分类整理
--- @class Sango
Sango = {
    --- 布尔值
    Boolean = {},

    --- 字符串
    String = {},

    --- 数字
    Number = {},

    --- 表
    Table = {},

    --- 检查target是否是所给值的一个
    --- @param target any
    --- @param ... any
    --- @return boolean
    AllowValue = function(target, ...)
        for _, v in ipairs({ ... }) do
            if target == v then
                return true
            end
        end

        return false
    end,

    --- 第二个以及以后的参数与第一个相同则true，任意一个不同则false
    --- @param target any
    --- @param ... any
    --- @return boolean
    MustBeTarget = function(target,...)
        for _,v in pairs({...}) do
            if v ~= target then
                return false
            end
        end

        return true
    end,

    --- 获取所有参数的种类列表
    --- @param ... any
    --- @return table<integer,string>
    GetTypeList = function(...)
        local result = {}

        for k, v in ipairs({ ... }) do
            result[k] = type(v)
        end

        return result
    end
}

--#region Sango.Boolean

--- 用 1 和 0 来代表 true 和 false
--- @param boolean boolean
--- @return integer 1 or 0
function Sango.Boolean.ToNumber(boolean)
    if boolean then
        return 1
    else
        return 0
    end
end

--- 如果是布尔值true，数字1，字符串"true"(不区分大小写)，返回true，否则返回false
--- @param any boolean|number|string
--- @return boolean
function Sango.Boolean.Prase(any)
    local _type = type(any)

    if _type == "boolean" then
        return any
    end

    if _type == "number" then
        return any == 1
    end

    if _type == "string" then
        return any:lower() == "true"
    end

    return false
end

--- 任意一个为true，则结果为true，否则为false
--- @param ... boolean
--- @return boolean
function Sango.Boolean.AnyTrue(...)
    for _, bool in ipairs({ ... }) do
        if bool then
            return true
        end
    end
    return false
end

--- 任意一个为false，则结果为false，否则为true
--- @param ... boolean
--- @return boolean
function Sango.Boolean.AnyFalse(...)
    for _, bool in ipairs({ ... }) do
        if not bool then
            return false
        end
    end
    return true
end

--#endregion

--#region Sango.String

--- 给字符串多套一层双引号
--- @param str string
--- @return string
function Sango.String.AddShell(str)
    return "\"" .. str .. "\""
end

--- 去掉字符串的一层双引号
--- @param str string
--- @return string
function Sango.String.RemoveShell(str)
    if str:sub(1, 2) == "\\\"" and str:sub(-2, -1) == "\\\"" then
        str = str:sub(3, -3)
    end
    return str
end

--- 从字符串开头移除所有空格
--- @param str string
--- @return string
function Sango.String.TrimStart(str)
    for i = 1, str:len() do
        if str:sub(i, i) ~= " " then
            return str:sub(i)
        end
    end
    return ""
end

--- 从字符串末尾移除所有空格
--- @param str string
--- @return string
function Sango.String.TrimEnd(str)
    for i = -1, -str:len(), -1 do
        if str:sub(i, i) ~= " " then
            return str:sub(1, i)
        end
    end
    return ""
end

--- 移除字符串头尾所有空格
--- @param str string
--- @return string
function Sango.String.Trim(str)
    return Sango.String.TrimEnd(Sango.String.TrimStart(str))
end

--- 在特殊位置(word)断开字符串
--- @param str string 要处理的字符串
--- @param word string? 特殊字符,不传参数就是把str分解成单个string字符放在table里，传入空字符串等效于空格
--- @param save_word boolean? 指示是否在每个断开的位置保存word, true就是{字符..word,字符..word}
--- @return table<integer,string>
function Sango.String.Split(str, word, save_word)
    --#region 没提供word，断开所有字符，并返回table
    if word == nil then
        local result = {}
        for i = 1, str:len() do
            result[i] = str:sub(i, i)
        end
        return result
    end
    --#endregion

    --#region 处理异常参数
    if word == "" then word = " " end
    save_word = save_word or false
    --#endregion

    --#region 处理字符串

    local result = {}
    local index = 1
    local word_start, word_end

    repeat
        word_start, word_end = str:find(word, index)

        if word_start == nil then
            break
        else
            table.insert(result, str:sub(index, word_start - 1))
            if save_word then
                table.insert(result, word)
            end
            index = word_end + 1
        end
    until false

    if index < str:len() then
        table.insert(result, str:sub(index))
    end

    return result

    --#endregion
end

--- 把第一个字符转为大写
--- @param str string
--- @return string
--- @return integer
function Sango.String.FirstToUpper(str)
    return str:gsub("^%l", string.upper)
end

--- 把第一个字符转为小写
--- @param str string
--- @return string
--- @return integer
function Sango.String.FirstToLower(str)
    return str:gsub("^%l", string.lower)
end

--#region Sango.String.Match

--- 匹配字符串中的一些值
Sango.String.Match = {
    --- 常用的正则表达式
    Patterns = {
        Number = "%d+%.?%d+",
        Boolean = "[true]|[false]",
        String = "\".+\""
    },

    First = {}
}

for k, v in pairs(Sango.String.Match.Patterns) do
    Sango.String.Match.First[k] = function(str)
        return str:match(v)
    end
end

--#endregion

--#endregion

--#region Sango.Table

--- 打印一个表
function Sango.Table.Print(tab)
    for k, v in pairs(tab) do
        print(
                tostring(k) .. " = " .. tostring(v)
        )
    end
end

--- 将很多很多表糅合起来，优先级依次递减
--- @param ... table
--- @return table
function Sango.Table.MixTogether(...)
    local result = {}
    for _, tab in ipairs({ ... }) do
        for k, v in pairs(tab) do
            if result[k] == nil then
                result[k] = v
            end
        end
    end
    return result
end

--- 复制一个表
--- @param tab table
--- @return table
function Sango.Table.Copy(tab)
    local result = {}
    for k, v in pairs(tab) do
        result[k] = v
    end
    return result
end

--- 深度复制一个表
--- @param tab table
--- @return table
function Sango.Table.DeepCopy(tab)
    local result = {}
    for k, v in pairs(tab) do
        if type(k) == "table" then
            k = Sango.Table.DeepCopy(k)
        end
        if type(v) == "table" then
            v = Sango.Table.DeepCopy(v)
        end
        result[k] = v
    end
    return result
end

--- 拆开一个表，这会清空这个表
--- @param tab any
--- @return ... any
function Sango.Table.Destroy(tab)
    for key, value in pairs(tab) do
        tab[key] = nil
        return value, Sango.Table.Destroy(tab)
    end
end

--- 拆开一个表，这不会清理原表
function Sango.Table.Unpack(tab)
    return Sango.Table.Destroy(Sango.Table.Copy(tab))
end

--#region Sango.Table.ToString

--- 包含了许多表转字符串的方法
Sango.Table.ToString = {}

--- 连接表内的字符串
--- @param tab any
--- @return string
function Sango.Table.ToString.ConnectValues(tab)
    local result = ""
    for _, v in pairs(tab) do
        if type(v) == "string" and v ~= "" then
            result = result .. v
        end
    end
    return result
end

--- 完全意义上的列表转字符串
--- @param tab table
--- @param string_addShell boolean 指示是否应该给字符串加壳,加壳后更容易分辨出字符串
--- @return string
--- @private
function Sango.Table.ToString.Full(tab, string_addShell)
    --- 处理键或值 (不应调用这个方法，该方法为方法(Sango.Table.Tostring.Full)服务)
    --- @param k_v any key或者value
    --- @param _string_addShell boolean 指示是否应该给字符串加壳
    --- @return any
    local function Process(k_v, _string_addShell)
        --声明一个_type用于储存key的type
        local _type = type(k_v)

        if _type == "string" then
            if _string_addShell then
                --为string添加\"\"，便于区分
                return Sango.String.AddShell(k_v)
            else
                return k_v
            end
        elseif _type == "table" then
            --特殊化处理table
            return Sango.Table.ToString.Full(k_v, _string_addShell)
        else
            --其他直接可以return
            return tostring(k_v)
        end
    end

    local result = "{"
    for k, v in pairs(tab) do
        --处理table中的k,v.横着太长了 =.=
        k, v = Process(k, string_addShell), --Process的代码在这个函数的子函数里，所以为什么要分开呢=.=
        Process(v, string_addShell)

        result = result .. "[" .. k .. "]" .. "=" .. v .. ","
    end

    if result == "{" then
        return "{}"
    else
        return result:sub(1, -2) .. "}"
    end
end

--- 列表转换为字符串列表
--- @param tab table
--- @param string_addShell boolean 指示是否应该给字符串加壳,加壳后更容易分辨出字符串
--- @param lastKey? string 上一个没有连接到值的键
--- @return string
function Sango.Table.ToString.List(tab, string_addShell, lastKey)
    local result = ""
    lastKey = lastKey or ""
    --遍历表中的每一个值
    for k, v in pairs(tab) do
        --处理键
        local k_type = type(k)
        if k_type == "string" and string_addShell then
            k = Sango.String.AddShell(k)
        else
            k = tostring(k)
        end
        k = lastKey .. "[" .. k .. "]"

        --处理值
        local v_type = type(v)
        if v_type == "table" then
            v = Sango.Table.ToString.List(v, string_addShell, k)
            result = result .. v .. "\n"
        else
            if v_type == "string" then
                if string_addShell then
                    v = Sango.String.AddShell(v)
                end
            else
                v = tostring(v)
            end
            result = result .. k .. "=" .. v .. "\n"
        end
    end

    if result == "" then
        --为空的table特殊标记一下
        return "{empty}"
    else
        return result:sub(1, -2)
    end
end

--#endregion

--#region Santo.Table.Exist

--- 包含查看表中是否存在某个东西的方法
Sango.Table.Exist = {}

--- 查看表里面是否存在某个东西
--- @param tab table
--- @param any any
--- @return boolean
function Sango.Table.Exist.Any(tab, any)
    for k, v in pairs(tab) do
        if k == any or v == any then
            return true
        end
    end
    return false
end

--- 查看表里面是否存在某个值
--- @param tab table
--- @param value any
--- @return boolean
function Sango.Table.Exist.Value(tab, value)
    local result = false
    for _, v in pairs(tab) do
        if v == value then
            return true
        end
    end
    return result
end

--- 查看表里面是否存在某个键
--- @param tab table
--- @param key any
--- @return boolean
function Sango.Table.Exist.Key(tab, key)
    for k, _ in pairs(tab) do
        if k == key then
            return true
        end
    end
    return false
end

--- 查看表里面是否存在子表
--- @param tab table
--- @return boolean
function Sango.Table.Exist.SonTable(tab)
    for _, v in tab do
        if type(v) == "table" then
            return true
        end
    end
    return false
end

--#endregion

--#region Table.Get

--- 获取表中的某个东西
Sango.Table.Get = {}

--- 获取表的元素个数
--- @param tab table
--- @return number
function Sango.Table.Get.ElementNumber(tab)
    local i = 0
    for _, _ in pairs(tab) do
        i = i + 1
    end
    return i
end

--- 获取表中的某个值及其位置
--- @param tab table
--- @param value any
--- @return boolean
--- @return any
function Sango.Table.Get.Value(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return true, k
        end
    end
    return false, nil
end

--#region Sango.Table.Get.Same

--- 获取表中相同的部分
Sango.Table.Get.Same = {}

--- 获取表中相同的值
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Same.Value(A, B)
    local result = {}
    for _, v1 in pairs(A) do
        for _, v2 in pairs(B) do
            if v1 == v2 then
                table.insert(result, v1)
            end
        end
    end
    return result
end

--- 获取表中相同的键
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Same.Key(A, B)
    local result = {}
    for k1, _ in pairs(A) do
        for k2, _ in pairs(B) do
            if k1 == k2 then
                table.insert(result, k1)
            end
        end
    end
    return result
end

--- 获取表中相同的对
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Same.Pair(A, B)
    local result = {}
    for k, v in pairs(A) do
        if B[k] == v then
            result[k] = v
        end
    end
    return result
end

--#endregion

--#region Santo.Table.Get.Diffrent

--- 获取表中不同的部分
Sango.Table.Get.Different = {}

--- 获取表中不同的值
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Different.Value(A, B)
    local result = {}
    for _, v in pairs(A) do
        local exist, position = Sango.Table.Get.Value(B, v)
        if exist then
            B[position] = nil
        else
            table.insert(result, v)
        end
    end

    for _, v in pairs(B) do
        if not Sango.Table.Exist.Value(A, v) then
            table.insert(result, v)
        end
    end
    return result
end

--- 获取表中不同的键
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Different.Key(A, B)
    local result = {}
    for k, _ in pairs(A) do
        if B[k] == nil then
            table.insert(result, k)
        else
            B[k] = nil
        end
    end

    for k, _ in pairs(B) do
        if A[k] == nil then
            table.insert(result, k)
        end
    end
    return result
end

--- 获取表中不同的对
--- @param A table
--- @param B table
--- @return table
function Sango.Table.Get.Different.Pair(A, B)
    local result = {}
    for k, v in pairs(A) do
        if B[k] == v then
            B[k] = nil
        else
            result[k] = v
        end
    end

    for k, v in pairs(B) do
        if A[k] ~= v then
            result[k] = v
        end
    end
    return result
end

--#endregion

--#endregion

--#endregion

--#region Sango.Number

--- 求平方和 a[1]^2 + a[2]^2 + a[3]^2 + ... = ?
--- @return number
--- @param ... number
function Sango.Number.SPSMD(...)
    local i = 0
    for _, v in pairs({ ... }) do
        i = i + v * v
    end
    return i
end

--- 求和 a[1] + a[2] + a[3] + ... = ?
--- @param ... number
--- @return number
function Sango.Number.SUM(...)
    local i = 0
    for _, v in pairs({ ... }) do
        i = i + v
    end
    return i
end

--- 求绝对值
--- @param num number
--- @return number 非负数 (number >= 0)
function Sango.Number.ABS(num)
    if num >= 0 then
        return num
    else
        return -num
    end
end

--- 去除小数部分, 例如-32.321890321 -> -32
--- @param num number
--- @return integer
function Sango.Number.ToInteger(num)
    if num >= 0 then
        return math.floor(num)
    else
        return math.floor(num) + 1
    end
end

--- 求平方和开根号 sqrt(SPSMD(...))
--- @return number
function Sango.Number.MOD(...)
    return math.sqrt(Sango.Number.SPSMD(...))
end

--- 将坐标转换为MC里的角度yaw,pitch(水平, 竖直)
--- @param x number
--- @param y number
--- @param z number
--- @return number yaw 水平角度
--- @return number pitch 垂直角度
function Sango.Number.XYZToMCDeg(x, y, z)
    --- @diagnostic disable-next-line: deprecated 在这行禁用警告,math.atan2过时了
    return math.deg(-math.atan2(x, z)), -math.deg(math.atan2(y, math.sqrt(x * x + z * z)))
end

--- 还有xyz三个参量的table转为yaw,pitch
--- @param point table
--- @return number yaw 水平角度
--- @return number pitch 垂直角度
function Sango.Number.PointToDeg(point)
    return Sango.Number.XYZToMCDeg(point.x,point.y,point.z)
end

--#endregion
