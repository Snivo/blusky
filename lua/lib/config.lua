local default = {
    commandString = "/"
}

if !file.Exists("blusky/config.txt", "DATA") then
    file.CreateDir("blusky")
    file.Write("blusky/config.txt", util.TableToJSON(default))
end

-- blusky.config = util.JSONToTable(file.Read("blusky.config.txt"))
blusky.config = default