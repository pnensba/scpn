(
(
d = (); // création d'un dictionnaire
// à adapter suivant le répertoire       MODIFIABLE
d.proot = "/Users/kieran/Desktop/tomorrow_night/";
d.proot = "/data/pngit/kieran/";


// création de 4 bus stéréo
(
d.h = Array.new(4);
d.hpairs = Array.new(4);
4.do({|i|
	d.h.add(Bus.audio(s,2));
	d.hpairs.add([0,1]);
	}
);
);

// assurer les connexions              MODIFIABLE
d.hpairs = [[0,1], [2,3], [0,3], [1,2]];


~myQuark = Quarks(
	reposPath: "",
	localPath: d.proot++"quarks/"
);
~myQuark.install( "readdir" );
);

s = Server.internal; // for scoping!!
//s = Server.local;
Server.default = s;
//s.options.device = "Digidesign HW ( 002 )";
//s.options.device = "JackRouter";
//s.options.device = "Fireface 400 (7DF)";

s.boot;
s.doWhenBooted({
	d.dirsons = d.proot++"data/";
	d.bufs = Buffer.readDir(d.dirsons, ext:"wav", bufnumOffset:0, numChannels: 2);

	(
		SynthDef("magneto", { |bufnum, out=1, amp=1|
			Out.ar(out, amp*PlayBuf.ar(2, bufnum, BufRateScale.kr(bufnum), loop:0, doneAction:2));
		}).load(s);

		SynthDef("connect", { |bus, channelIndex, out|
			// channelIndex is left (0) or right (1)
			Out.ar(out, In.ar(bus+channelIndex,1));
		}).load(s);

		4.do({|i|
			// connect gauche
			Synth.new(\connect, [\bus,d.h[i].index,\channelIndex,0,\out, d.hpairs[i][0]], addAction: \addToTail);
			// connect droite
			Synth.new(\connect, [\bus,d.h[i].index,\channelIndex,1,\out, d.hpairs[i][1]], addAction: \addToTail);
			}
		);
	);

	(
		~dur = {|n=0| d.bufs[n].numFrames/d.bufs[n].sampleRate};
		// joue son n sur couple hp h avec amplitude a
		~joue = {|n,h,a=1|
			var synth;
			synth = Synth.new(\magneto, [\bufnum,d.bufs[n].bufnum,\out,d.h[h].index,\amp,a], addAction: \addToHead);
		};
	);
	(
		// d.morceaux est la liste des morceaux QUI RESTE A JOUER

		// ~scramble construit une liste aléatoire des 20 morceaux
		// et s'assurre que le dernier morceau joué ne sera pas le prochain tiré
		~scramble = {
			d.morceaux = (0..20).scramble;
			while ({d.morceaux[20]==d.morceau},
				{d.morceaux = (0..20).scramble;}
			);
		};

		// dm = durée minimale du délai
		// dM = durée maximale du délai
		// hp n° du couple de hps
		(
			~tirage = {|delaiDelta=0, delaiMax=240, hp=0, startnow=false|
				var delai, dur, morceau, synth;
				// si la liste est vide alors il faut en recréer une
				if (d.morceaux.size()==0,
					{~scramble.()},
					{}
				);
				morceau = d.morceaux.pop(); // le morceau courant
				// on tire une durée au hasard
				delai = delaiDelta+((1.0.sum3rand+1)*(delaiMax / 2.0));
				("délai choisi: "++delai).postln;
				("morceau : "++morceau).postln;
				if (startnow==false) {delai.wait;}; // on attend

				synth = ~joue.(morceau,hp); // on joue le morceau sur son couple hp
				dur = ~dur.(morceau);
				("durée du morceau: "++dur).postln;
				dur.wait; // on attend la fin
				~tirage.(0,delaiMax,hp);
			};
		);
		(
			~lancement = {
				{~tirage.(hp:0, startnow:true)}.fork;
				{~tirage.(delaiDelta:60,hp:1)}.fork;
				{~tirage.(delaiDelta:120,hp:2)}.fork;
				{~tirage.(delaiDelta:180,hp:3)}.fork;
			};
		);
	);
	}
)
)

~lancement.();



