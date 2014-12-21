s.boot
ProxySpace.push(s)

b = Buffer.read(s, "/data/wstn/bea1.wav")
c = Buffer.read(s, "/data/wstn/jeanne1.wav")
d = Buffer.read(s, "/data/wstn/mix1.wav")
~jeanne.ar(4)
~mix.ar(4)
~bea.ar(4)

~bea = {0.1*PlayBuf.ar(2, b, BufRateScale.kr(b), loop:0)}

~jeanne = {0.1*PlayBuf.ar(2, c, BufRateScale.kr(c), loop:0)}
~jeanne = {PanAz.ar(4, PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1),LFSaw.kr(0.05),1,1.5)}

~jeanne = {PanAz.ar(4, PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1),-1,1,1.5)}


~mix = {0.1*PlayBuf.ar(, d, BufRateScale.kr(d), loop:0)}
~mix = {PanAz.ar(4, PlayBuf.ar(2, d, BufRateScale.kr(d), loop:1),LFSaw.kr(0.05),1,1.5)}


~jeanne = {PanAz.ar(4, PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1),-0.5,1,1.5)}
~mix = {PanAz.ar(4, PlayBuf.ar(1, d, BufRateScale.kr(d), loop:1),0.5,1,1.5)}


~jeanne = {Out.ar(0, PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1))}
~mix = {Out.ar(1, PlayBuf.ar(1, d, BufRateScale.kr(d), loop:1))}

~jeanne = {PanAz.ar(4, PlayBuf.ar(1, c, BufRateScale.kr(c), loop:1),LFSaw.kr(0.05),1,2)}
~mix = {PanAz.ar(4, PlayBuf.ar(1, d, BufRateScale.kr(d), loop:1),LFSaw.kr(0.05,1),1,2)}


~mix.pause
~jeanne.pause
~jeanne.play
~mix.play
~mix.resume
~jeanne.resume