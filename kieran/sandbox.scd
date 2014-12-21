
~dur.(20)
// joue son n sur couple hp h avec amplitude a
~joue.(0,0,0.1)
~joue.(1,1,0.1)
~joue.(10,2,0.1)
~joue.(10,3,0.1)

d.ls.free

d.hpairs[1]=[2,3]
d.hpairs[2]=[0,3]
d.hpairs[3]=[1,2]

s.queryAllNodes
s.sendMsg(\n_free, 1008);
s.kill(1008)
Server.free
~joue.(0, 6, 0.11)

s.scope(numChannels:8);
Quarks.gui

	SynthDef("magneto", { |bufnum, out=1, amp=1|
 Out.ar(out, amp*PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), loop:0, doneAction:2));
}).load(s);

~dur = {|n=0| d.bufs[n].numFrames/d.bufs[n].sampleRate};
~joue = {|n,out,a=1| var i;
		i = Synth.new(\magneto, [\bufnum,d.bufs[n].bufnum,\out,out,\amp,a]);
		[i, ~dur.(n)]};
});

s.makeGui
Server.local.makeGui
Server.internal.makeGui
