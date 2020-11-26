function NavigationFloatingWin()
    -- get the editor's max width and height
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    t = {key1 = 'value1', key2 = false}
    print(t)
    print(t.key1)
    print(t.key2)

    t.key2 = nil
    print(t.key2)
    t.newKey = {}
    print(t.newKey)

    u = {['@!#'] = 'qbert', [{}] = 1729, [6.28] = 'tau'}
    print(u[6.28])

    for k, v in pairs(u) do
        print(k, v)
    end

    print(_G['_G'] == _G) --true
    print(_G['a'] == a) --true
    print(_G['3'] == 3) --false

    v = {'value1', 'value2', 3.33, 'max'}
    for i = 1, #v do
        print(v[i])
    end

    f1 = {a = 1, b = 2}
    f2 = {a = 2, b = 3}

    metafraction = {}
    function metafraction.__add(f1, f2)
        sum = {}
        sum.b = f1.b + f2.b
        sum.a = f1.a * f2.b + f2.a * f1.b
        return sum
    end

    setmetatable(f1, metafraction)
    setmetatable(f2, metafraction)
    s = f1 + f2
    print(s.a, s.b)

    defaultFavs = {animal = 'gru', food = 'donuts'}
    myFav = {food = 'pizza'}
    setmetatable(myFav, {__index = defaultFavs})
    print(myFav.animal)

    Dog = {}
    function Dog:new()
        newObj = {sound = 'woof'}
        self.__index = self
        return setmetatable(newObj, self)
    end

    function Dog:makeSound()
        print('I say ' .. self.sound)
    end

    mrDog = Dog:new()
    mrDog:makeSound()

    -- create a new, scratch buffer, for fzf
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')

    -- if the editor is big enough
    if (width > 150 or height > 35) then
        -- fzf's window height is 3/4 of the max height, but not more than 30
        local win_height = math.min(math.ceil(height * 3 / 4), 30)
        local win_width

        -- if the width is small
        if (width < 150) then
            -- just subtract 8 from the editor's width
            win_width = math.ceil(width - 8)
        else
            -- use 90% of the editor's width
            win_width = math.ceil(width * 0.9)
        end

        -- settings for the fzf window
        local opts = {
            relative = "editor",
            width = win_width,
            height = win_height,
            row = math.ceil((height - win_height) / 2),
            col = math.ceil((width - win_width) / 2)
        }

        -- create a new floating window, centered in the editor
        local win = vim.api.nvim_open_win(buf, true, opts)
    end
end
