
// création de 4 bus stéréo
(
d.h = Array.new(4);
d.hpairs = Array.new(4);
4.do({|i|
	d.h.add(Bus.audio(s,2));
	d.hpairs.add([0,1]);
	}
);
)

(
SynthDef("magneto", { |bufnum, out=1, amp=1|
 Out.ar(out, amp*PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), loop:0, doneAction:2));
}).load(s);

SynthDef("connect", { |bus, channelIndex, out|
	// channelIndex is left (0) or right (1)
	Out.ar(out, In.ar(bus+channelIndex,1));
}).load(s);
);

(
// joue son n sur couple hp h avec amplitude a
~joue = {|n,h,a=1|
	Synth.new(\magneto, [\n,d.bufs[n].bufnum,\out,d.h[h].index,\amp,a], addAction: \addToHead);
	// connect gauche
	Synth.new(\connect, [\bus,d.h[h].index,\channelIndex,0,\out, d.hpairs[h][0]], addAction: \addToTail);
	// connect droite
	Synth.new(\connect, [\bus,d.h[h].index,\channelIndex,1,\out, d.hpairs[h][1]], addAction: \addToTail);
~dur.(n)
};
)


s.makeGui
// joue son n sur couple hp 1
d.h[1].scope()
~joue.(2,1,0.1)


s.scope()
d.h[0].index
