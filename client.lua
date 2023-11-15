local defaultProperties = {
    ["cylinder"] = {
        M_speed = 0.1,
        M_rate = 10,
        M_glow = 0.05,
        M_frequency = 8,
        M_amplitude = .005
    },
    ["ring"] = {
        M_speed = 0.1,
        M_rate = 10,
        M_glow = 0,
        M_frequency = 8,
        M_amplitude = .001
    },
    ["checkpoint"] = {
        M_speed = 0.0015,
        M_rate = 600,
        M_glow = 0.001,
        M_frequency = 5,
        M_amplitude = 0.0005
    },
    ["arrow"] = {
        M_speed = 0.1,
        M_rate = 10,
        M_glow = 0.05,
        M_frequency = 8,
        M_amplitude = .005
    },
    ["finish"] = {
        M_speed = 0.1,
        M_rate = 10,
        M_glow = 0.05,
        M_frequency = 8,
        M_amplitude = .005
    }
}

local markers = {}
local streaming = {}

function onClientMarkerDestroy()
    local data = markers[source]

    if data then
        if isElement(data.shader) then
            destroyElement(data.shader)
        end

        markers[source] = nil
    end
end

function onClientResourceStartReplaceModels()
    local modelsToReplace = {
        {
            txdFile = "files/textures/marker.txd",
            dffFile = "files/models/cylinder.dff",
            modelID = 1317,
            alphaTransparency = true,
            filteringEnabled = true,
        },
        {
            txdFile = "files/textures/marker.txd",
            dffFile = "files/models/hoop.dff",
            modelID = 1316,
            alphaTransparency = true,
            filteringEnabled = true,
        },
        {
            txdFile = "files/textures/marker.txd",
            dffFile = "files/models/diamond.dff",
            modelID = 1559,
            alphaTransparency = true,
            filteringEnabled = true,
        },
        {
            txdFile = "files/textures/marker.txd",
            dffFile = "files/models/finish.dff",
            modelID = 2614,
            alphaTransparency = true,
            filteringEnabled = true,
        },
    }
    for assetID = 1, #modelsToReplace do
        local modelData = modelsToReplace[assetID]
        local modelCol = modelData.colFile
        local modelTxd = modelData.txdFile
        local modelDff = modelData.dffFile
        local modelID = modelData.modelID

        if modelCol then
            local colData = engineLoadCOL(modelCol)

            if colData then
                engineReplaceCOL(colData, modelID)
            end
        end

        if modelTxd then
            local filteringEnabled = modelData.filteringEnabled
            local txdData = engineLoadTXD(modelTxd, filteringEnabled)

            if txdData then
                engineImportTXD(txdData, modelID)
            end
        end

        if modelDff then
            local dffData = engineLoadDFF(modelDff)

            if dffData then
                local alphaTransparency = modelData.alphaTransparency

                engineReplaceModel(dffData, modelID, alphaTransparency)
            end
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStartReplaceModels)

function findRotation3D(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1

    local yaw = math.deg(math.atan2(dx, dy))
    local pitch = math.deg(math.atan2(dz, math.sqrt(dx * dx + dy * dy)))

    if yaw < 0 then
        yaw = yaw + 360
    end

    if pitch < 0 then
        pitch = pitch + 360
    end

    return yaw, pitch
end

function createMarker(x, y, z, theType, size, r, g, b, a, r2, g2, b2, a2, properties)
    local size = size or 4.0
    local marker = createObject(theType == "cylinder" and 1317 or theType == "checkpoint" and 1317 or theType == "ring" and 1316 or theType == "arrow" and 1559 or 2614, x, y, z)

    if sourceResource then
        setElementParent(marker, getResourceDynamicElementRoot(sourceResource))
    end
    
    local data = {}
    
    data.theType = theType
    data.properties = properties or defaultProperties[theType]
    data.shader = dxCreateShader("files/shaders/shader.fx", data.properties, 0, 0, true, "object")
    data.size = size or 1
    data.colorA = {r, g, b, a}
    data.colorB = {r2, g2, b2, a2}

    engineSetModelLODDistance(getElementModel(marker), 30000)
    dxSetShaderValue(data.shader, "colorA", r, g, b, a)
    dxSetShaderValue(data.shader, "colorB", r2, g2, b2, a2)
    setObjectScale(marker, size, size, size)

    if theType == "checkpoint" then
        local sx, sy, sz = getObjectScale(marker)
        setObjectScale(marker, sx, sy, sz+100)
    end

    addEventHandler( "onClientElementDestroy", marker, onClientMarkerDestroy)
    engineApplyShaderToWorldTexture(data.shader, "*", marker)

    if isElementStreamedIn(marker) and isElementStreamable(marker) then
        streaming[marker] = true
    end
    markers[marker] = data
    return marker
end

function setMarkerIcon(theMarker, icon, offsetZ, size, r, g, b, a, r2, g2, b2, a2)
    local data = markers[theMarker]
    if not data then return end

    if isElement(data.icon) then
        destroyElement(data.icon)
        data.iconType = nil
        data.offsetZ = nil
        data.iconSize = nil
    end

    local x, y, z = getElementPosition(theMarker)
    data.offsetZ = offsetZ
    data.iconSize = size or data.size-1
    data.icon = createMarker(x, y, z + offsetZ, icon, data.iconSize, r, g, b, a, r2, g2, b2, a2)
    data.iconType = icon

    return data.icon
end

function setMarkerTarget(theMarker, x, y, z)
    local data = markers[theMarker]
    if not data then return end
    
    local element = data.icon and data.icon or theMarker
    local rx, ry, rz = getElementPosition(element)
    local yaw, pitch = findRotation3D(rx, ry, rz, x, y, z + (data.offsetZ or 0))
    data.target = {x, y, z}

    local offsetRotation = data.iconType == "arrow" or (not data.icon and data.theType == "ring")
    setElementRotation(element, 0, (offsetRotation and 90 or 0) + pitch,(offsetRotation and -90 or 0) - yaw)
end

function getMarkerTarget(theMarker)
    local data = markers[theMarker]
    if not data then return end

    return unpack(data.target)
end

function setMarkerColor(theMarker, r, g, b, a, r2, g2, b2, a2)
    local data = markers[theMarker]
    if not data then return end
    if not isElement(data.shader) then return end

    dxSetShaderValue(data.shader, "colorA", r, g, b, a)
    dxSetShaderValue(data.shader, "colorB", r2, g2, b2, a2)
end

function getMarkerType(theMarker)
    local data = markers[theMarker]
    if not data then return end

    return data.theType
end

function getMarkerIcon(theMarker)
    local data = markers[theMarker]
    if not data then return end

    return data.iconType
end

function setMarkerSize(theMarker, size)
    local data = markers[theMarker]
    if not data then return end

    setObjectScale(marker, size, size, size)

    if data.icon then
        setObjectScale(data.icon, data.iconSize, data.iconSize, data.iconSize)
    end
end

function getMarkerSize(theMarker)
    local data = markers[theMarker]
    if not data then return end

    return data.size
end

function getMarkerCount()
    local count = 0

    for _, v in markers do
        count = count + 1
    end

    return count
end

addEventHandler( "onClientElementDestroy", root, function()
    if streaming[source] and getElementType(source) == "object" then
        local data = markers[source]
            
        if data and isElement(data.shader) then
            destroyElement(data.shader)
            streaming[source] = false
            data.shader = nil
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    local data = markers[source]
    if not data then return end

    if not isElement(data.shader) then
        data.shader = dxCreateShader("files/shaders/shader.fx", data.properties, 0, 0, true, "object")
        dxSetShaderValue(data.shader, "colorA", unpack(data.colorA))
        dxSetShaderValue(data.shader, "colorB", unpack(data.colorB))
        engineApplyShaderToWorldTexture(data.shader, "*", source)
        streaming[source] = true
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    local data = markers[source]
    if not data then return end

    if isElement(data.shader) then
        destroyElement(data.shader)
        streaming[source] = false
        data.shader = nil
    end
end)
