local Logger = {}

function Logger.Info(...)
    print("[BlackKaitun][INFO]", ...)
end

function Logger.Warn(...)
    warn("[BlackKaitun][WARN]", ...)
end

function Logger.Error(...)
    warn("[BlackKaitun][ERROR]", ...)
end

return Logger