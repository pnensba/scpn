// uses wslib (from quarks)
(
s = Server.local;
Server.default = s;
//o.device = "Digidesign HW ( 002 )";
//s.options.device = "JackRouter";
//s.options.device = "Fireface 400 (7DF)";

s.boot;
s.doWhenBooted({
d = ();
d.dirsons = "/data/pngit/kieran/data/";
d.bufs = Buffer.readDir(d.dirsons,ext:"wav",bufnumOffset:0,numChannels: 2);
d.s = ();
d.sn = Array.new(21);
d.bufs.do({|b|
 var name;
 name = PathName(b.path).fileNameWithoutExtension;
 d.s[name.asSymbol] = b;
 d.sn.add(name.asSymbol);
});

d.h = Array.new(4);
4.do({|i|
	d.h.add(Bus.audio(s,2))}
);

(
SynthDef("magneto", { |bufnum, out=1, amp=1|
 Out.ar(out, amp*PlayBuf.ar(2,bufnum, BufRateScale.kr(bufnum),loop:0,doneAction:2));
}).load(s);

SynthDef("connect", { |bus, nChannel, out|
	Out.ar(out, In.ar(bus+nChannel,1));
}).load(s);
);

~dur = {|n=0| d.bufs[n].numFrames/d.bufs[n].sampleRate};

~joue = {
		|n,h,a=1| Synth.new(\magneto, [\n,d.bufs[n].bufnum,\out,d.h[h],\amp,a], addAction: \addToHead);
		~dur.(n)
	};

~connect = {|nbus, nChannel, out|
		Synth.new(\connect, d.h[nbus].index, nChannel, out, \addToTail);
};

});

)

~joue = {
		|n,b,a=1| Synth.new(\magneto, [\n,d.bufs[n].bufnum,\out,b,\amp,a], addAction: \addToHead);
		~dur.(n)
	};

s.queryAllNodes
~connect.(0, 0, 0);
~connect.(0, 1, 1);
~joue.(0, 6, 0.11)

d.h[0].index
Synth.new(\connect, 16,0,0);
{Out.ar(0, In.ar(18))}.play

