(

// pour relancer : poamme + a et pomme + entrée
// pour arrêter : pomme + shift + .

d = (); // création d'un dictionnaire
d.proot = thisProcess.nowExecutingPath.dirname++"/";

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
s.options.device = "install raph"; // choix de la carte
s.options.numOutputBusChannels = 12;
s.boot;

//
s.doWhenBooted({
	var w, meterView, meters, width, height, numIns, numOuts;
	s.freeAll();
	d.dirsons = d.proot++"sons/";
	d.namesons = getPathsInDirectory(d.dirsons);

	d.bufs = Buffer.readDir(d.dirsons, ext:"wav", bufnumOffset:0, numChannels: 1);
	(
		SynthDef("magneto", { |bufnum, out=1, amp=1|
			Out.ar(out, amp*PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop:1, doneAction:2));
		}).load(s);
		d.bufs.size.do({|i|
			Synth.new(\magneto, [\bufnum,d.bufs[i].bufnum,\out,i,\amp,1]);
			d.namesons[i].postln;
			(d.bufs[i].bufnum+1).postln;
		});
	);


	// works fine
	numIns = 0;
	numOuts = 12;

	width = ServerMeterView.getWidth(numIns, numOuts) * 2;
	height = ServerMeterView.height;

	w = Window("Installation Raphaël", Rect(50, 50, width, height), false);

	meterView = CompositeView(
		w,
		Rect(0, 0, width, height)
	);
	meters = [Server.local, Server.internal].collect { |server, i|
		var loc = (i * ServerMeterView.getWidth(numIns, numOuts))@0;
		ServerMeterView(server, meterView, loc, numIns, numOuts)
	};

	w.front;

});
)

