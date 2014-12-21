Quarks.gui
/*
AmbIEM will provide
- PanAmbi1O
- DecodeAmbi1O
*/

Server.default = s = Server.internal;
s.boot;
// 2D
a = VBAPSpeakerArray.new(2, [0, 45, 90, 135, 180, -135, -90, -45]); // 8 channel ring

a.speakers[1].dump;

b = a.loadToBuffer;
(
x = { |azi = 0, ele = 0, spr = 0|
	VBAP.ar(8, PinkNoise.ar(0.2), b.bufnum, azi, ele, spr);
}.scope;
)

(
VBAPSpeakerArray.new(3, [[45, -45], [45, 45],
				[-67.5, 14.97], [67.5, 14.97], [-112.5, 14.97], [112.5, 14.97], [-157.5, 14.97], [157.5, 14.97], [-45, 0], [45, 0], [-90, 0], [90, 0], [-135, 0], [135, 0], [0, 0], [180, 0]]); // zig zag partial dome
)