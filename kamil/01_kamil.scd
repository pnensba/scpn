
d = (); // création d'un dictionnaire
d.root = thisProcess.nowExecutingPath.dirname++"/";
d.sons = (d.root++"audio/*.wav").pathMatch;

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
// s.options.device
s.options.sampleRate = 48000;
s.boot;

s.doWhenBooted({
true.while({
	n = d.sons.size.rand;
	("joue le son : "+(n+1)).postln;
	b = Buffer.read(s, d.sons[n]);
		1.wait;
	m = {Out.ar(0, PlayBuf.ar(2, b.bufnum, rate:1))}.play;
	(b.numFrames/b.sampleRate).wait;
	5.wait;
	})
});
