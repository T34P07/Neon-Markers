local ring = createMarker(2462.07446, -1658.84827, 13, "ring", 7, 1, 0, .7, 1, .5, .5, 1, 1)
setElementRotation(ring, 0, 90, 0)

local ring2 = createMarker(2462.07446-30, -1658.84827, 13 + 30, "ring", 7, .3, .5, 0, 0, .7, .8, 0, 1)
setElementRotation(ring2, 0, 90, 0)

local ring3 = createMarker(2462.07446-60, -1658.84827+30, 13 + 60, "ring", 7, 0, .5, 0, 1, 0, .8, 1, 1)
setElementRotation(ring3, 0, 90, 0)

setMarkerIcon(ring, "arrow", 3, nil, 0, 0, 0, 0, 1, 1, 1, 1)
setMarkerTarget(ring, getElementPosition(ring2))
setMarkerTarget(ring2, getElementPosition(ring3))

local arrow = createMarker(2495.40698, -1690.81873, 14.5, "arrow", 1, 1, 0, .7, 1, .5, .5, 1, 1)

local cylinder = createMarker(2459.39648, -1691.13721, 12.5, "cylinder", 1, 1, 0, .7, 1, .5, .5, 1, 1)

local checkpoint = createMarker(2498.63208, -1667.88818, 12.5, "checkpoint", 3, 1, 0, .7, 1, .5, .5, 1, 1)
local checkpoint2 = createMarker(2498.63208, -1667.88818+10, 12.5, "checkpoint", 3, 1, 0, .7, 1, .5, .5, 1, 1)
local checkpoint3 = createMarker(2498.63208-10, -1667.88818+10, 12.5, "checkpoint", 3, 1, 0, .7, 1, .5, .5, 1, 1)

setMarkerIcon(checkpoint, "arrow", 3, nil, 0, 0, 0, 0, 1, 1, 1, 1)
setMarkerTarget(checkpoint, getElementPosition(checkpoint2))

setMarkerIcon(checkpoint2, "arrow", 3, nil, 0, 0, 0, 0, 1, 1, 1, 1)
setMarkerTarget(checkpoint2, getElementPosition(checkpoint3))

setMarkerIcon(checkpoint3, "finish", 3, 1, 1, 0, 0, 0, 1, 0, 0, 1)
setMarkerTarget(checkpoint3, getElementPosition(ring))


local cylinder2 = createMarker(2487.89502, -1680.72937, 12.5, "cylinder", 1, 1, 0, .7, 0, .5, .8, 0, 1)
local cylinder3 = createMarker(2487.89502-2, -1680.72937, 12.5, "cylinder", 1, .3, .5, .7, 0, .5, .8, 1, 1)
local cylinder4 = createMarker(2487.89502+2, -1680.72937, 12.5, "cylinder", 1, 0, 0, .0, 0, 1, 1, 1, 1)

local arrow2 = createMarker(2487.89502, -1680.72937-2, 13.25, "arrow", 1, 1, 0, .7, 0, .5, .8, 0, 1)
local arrow3 = createMarker(2487.89502-2, -1680.72937-2, 13.25, "arrow", 1, .3, .5, .7, 0, .5, .8, 1, 1)
local arrow4 = createMarker(2487.89502+2, -1680.72937-2, 13.25, "arrow", 1, 0, 0, .0, 0, 1, 1, 1, 1)

local cylinder5 = createMarker(2487.89502, -1680.72937+2, 12.5, "cylinder", 1, 1, 0, .7, 0, .5, .8, 0, 1,
{
    M_speed = 0.1,
    M_rate = 10,
    M_glow = 0,
    M_frequency = 0,
    M_amplitude = .005
})

local cylinder6 = createMarker(2487.89502-2, -1680.72937+2, 12.5, "cylinder", 1, .3, .5, .7, 0, .5, .8, 1, 1,
{
    M_speed = 0.1,
    M_rate = 50,
    M_glow = 0.05,
    M_frequency = 15,
    M_amplitude = .005
})

local cylinder7 = createMarker(2487.89502+2, -1680.72937+2, 12.5, "cylinder", 1, 0, 0, .0, 0, 1, 1, 1, 1,
{
    M_speed = 0.1,
    M_rate = 20,
    M_glow = 0.5,
    M_frequency = 8,
    M_amplitude = .005
})
