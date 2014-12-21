
d = (); // création d'un dictionnaire
d.root = thisProcess.nowExecutingPath.dirname++"/";
d.busize = 48000;

d.intro = (d.root++"audio/0i/*.wav").pathMatch;

d.i1 = (d.root++"audio/i1/*.wav").pathMatch;
d.p1 = (d.root++"audio/p1/*.wav").pathMatch;
d.s1 = (d.root++"audio/s1/*.wav").pathMatch;

d.i2 = (d.root++"audio/i2/*.wav").pathMatch;
d.p2 = (d.root++"audio/p2/*.wav").pathMatch;
d.s2 = (d.root++"audio/s2/*.wav").pathMatch;

d.i3 = (d.root++"audio/i3/*.wav").pathMatch;
d.p3 = (d.root++"audio/p3/*.wav").pathMatch;
d.s3 = (d.root++"audio/s3/*.wav").pathMatch;

d.i4 = (d.root++"audio/i4/*.wav").pathMatch;
d.p4 = (d.root++"audio/p4/*.wav").pathMatch;

d.p5 = (d.root++"audio/p5/*.wav").pathMatch;

d.n = d.sons.size;


// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
// s.options.device
s.options.sampleRate = 48000;
s.boot;

s.doWhenBooted({
// Intro générale
n = 4.rand+2;
(n+" sons ont été choisis").postln;

(0..7).scramble.keep(n).sort.do({|i|
	i.postln;
	b = Buffer.read(s, d.intro[i]);
	1.wait;
	m = {Out.ar(0, PlayBuf.ar(1, b.bufnum, rate:1))}.play;
	(b.numFrames/b.sampleRate).wait;
	0.5.wait;
});

	1.wait;




});

