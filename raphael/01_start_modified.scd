(

// pour relancer : poamme + a et pomme + entrée
// pour arrêter : pomme + shift + .

d = (); // création d'un dictionnaire
d.proot = thisProcess.nowExecutingPath.dirname++"/";

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
s.options.device = "install raph"; // choix de la carte
//s.options.device = "Fireface 400 (7DF)"; // choix de la carte
s.options.numOutputBusChannels = 18;
s.boot;

//
s.doWhenBooted({
	var w, meterView, meters, width, height, numIns, numOuts, nout;
	s.freeAll();
	d.dirsons = d.proot++"sons/";
	d.namesons = getPathsInDirectory(d.dirsons);
	d.mag = Array.newClear(16);

	d.bufs = Buffer.readDir(d.dirsons, ext:"wav", bufnumOffset:0, numChannels: 1);
	SynthDef("magneto", { |bufnum, out=1, amp=1, rate= 0|
		Out.ar(out, amp*PlayBuf.ar(1, bufnum, rate, loop:1, doneAction:2));
	}).load(s);
	30.wait;
	"loaded".postln;

	d.bufs.size.do({|i|
		if (i>7, {nout=i+2},{nout=i});
		d.mag[i] = Synth.new(\magneto, [\bufnum,d.bufs[i].bufnum,\out,nout,\amp,1,\rate,0]);
	});
	"synths created".postln;

	10.wait;
	"go!".postln;
	d.bufs.size.do({|i|
		d.mag[i].set(\rate, 1);
	});
});
)
