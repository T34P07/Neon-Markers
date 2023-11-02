# Neon-Markers
A shader that makes markers prettier!

# Authors
- [T34P07](https://github.com/T34P07)
- [Rick](https://github.com/httpRick)

# Installation
1. Download resource.
2. Place the resource in your server resources folder.

# Documentation
createMarker(int x, int y, int z, string theType, int size = 1, int r, int g, int b, int a, int r2, int g2, int b2, int a2, table properties = defaultProperties): object
setMarkerIcon(object theMarker, string icon, int offsetZ, int size, int r, int g, int b, int a, int r2, int g2, int b2, int a2): object
setMarkerTarget(object theMarker, int x, int y, int z)
getMarkerTarget(object theMarker): int x, int y, int z
setMarkerColor(object theMarker, int r, int g, int b, int a, int r2, int g2, int b2, int a2)
getMarkerType(object theMarker): string
getMarkerIcon(object theMarker): string
setMarkerSize(object theMarker, int size)
getMarkerSize(object theMarker): int
