((

// pour relancer pomme + entrée

d = (); // création d'un dictionnaire
d.proot = thisProcess.nowExecutingPath.dirname++"/";

// charge des librairies tierces (quarks)
~myQuark = Quarks(
	reposPath: "",
	localPath: d.proot++"quarks/"
);
~myQuark.install( "readdir" );
);

// boot server (réglages carte son)
s = Server.internal;
Server.default = s;
s.options.device = "install raph"; // choix de la carte
s.boot;

//
s.doWhenBooted({
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
});
)
