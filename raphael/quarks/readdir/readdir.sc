+ Buffer { // read all files in directory to a dir

	*readMultiple {  |names, path, bufnumOffset, numChannels = 1, server, notify = true, action|
		var buffers, msgs;

		server = server ? Server.default;
		path = path.standardizePath.withTrailingSlash;

		msgs = names.collect({ |name, i|
			var buffer;
			buffer = Buffer(server, numChannels: numChannels, bufnum: bufnumOffset !? { bufnumOffset + numChannels*i });
			buffers = buffers.add( buffer );
			buffer.cache; // extra cache needed here?
			buffer.allocReadMsg( (path ++ name), 0, -1, {|buf|["/b_query",buf.bufnum]});
			});

		if(notify) { buffers.do({ |buffer, i|
			("\t" ++ buffer.bufnum ++ " : " ++ names[i] ).postln; }) };

		{ 	server.sync( nil, msgs );
			if(notify) { "reading % buffers from folder '%/' done\n"
						.postf( names.size, path.basename ); };
			action.value( buffers );
		}.fork;

		^buffers;
		}

	*readDir { |path, bufnumOffset, numChannels = 1, ext ="wav", server, notify = true, nlevels = inf, action|
		var names;
		path = path.standardizePath.withTrailingSlash;
		names = path.getPathsInDirectory(ext.removeItems("."), nlevels);
		if(notify) { ("\nread " ++ names.size ++ " files to buffers:").postln;
			path.postln; };
		^Buffer.readMultiple(names, path, bufnumOffset, numChannels, server, notify, action);
		}
	}