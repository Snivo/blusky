local default = {

}

if !file.Exists("blusky/config.txt", "DATA") then
    file.CreateDir("blusky")
    file.Create("blusky/config.txt", util.TableToJSON(default))
end

blusky.config = util.JSONToTable(file.Read("blusky.config.txt"))