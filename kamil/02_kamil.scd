
d = (); // création d'un dictionnaire
d.root = thisProcess.nowExecutingPath.dirname++"/";
d.sons = (d.root++"audio/*.wav").pathMatch;

d.nb_hps = 4;

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
// s.options.device
s.options.sampleRate = 48000;
s.boot;

s.doWhenBooted({

	// process 1
{true.while({
	d.n1 = d.sons.size.rand;
	("joue le son 1 : "+(d.n1+1)).postln;
	d.b1 = Buffer.read(s, d.sons[d.n1]);
	1.wait;

	// joue le son 1
	d.m1 = {PanAz.ar(d.nb_hps, PlayBuf.ar(1, d.b1.bufnum, rate:1),[-1,1].choose*(LFSaw.kr(rrand(0.05,0.2),2.0.rand)+1),1,2)}.play; // good one
	(d.b1.numFrames/d.b1.sampleRate).wait;
	d.b1.free; d.m1.free;
	rrand(1,4).wait;

	})}.fork;

	// process 2
{true.while({

	// pause
	rrand(20,25).wait;

	d.n2 = d.sons.size.rand;
	("joue le son 2 : "+(d.n2+1)).postln;
	d.b2 = Buffer.read(s, d.sons[d.n2]);
	1.wait;

	// joue le son 2
	d.m2 = {0.5*PanAz.ar(d.nb_hps, PlayBuf.ar(1, d.b2.bufnum, rate:1),[-1,1].choose*(LFSaw.kr(rrand(0.05,0.2),2.0.rand)+1),1,2)}.play; // good one
	(d.b2.numFrames/d.b2.sampleRate).wait;
	d.b2.free; d.m2.free;



	})}.fork;

});


