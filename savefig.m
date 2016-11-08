function savefig(fname, varargin)
	
% Usage: savefig(filename, fighdl, options)


%
% REQUIREMENT: Ghostscript. Version 8.57 works, probably older versions too, but '-dEPSCrop'
%          must be supported. I think version 7.32 or newer is ok.



	
	op_dbg=		false;												% Default value.
	
	% Compression
	compr=			[' -dUseFlateCompression=true -dLZWEncodePages=true -dCompatibilityLevel=1.6' ...
					 ' -dAutoFilterColorImages=false -dAutoFilterGrayImages=false ' ...
					 ' -dColorImageFilter=%s -dGrayImageFilter=%s'];	% Compression.
	lossless=		sprintf (compr, '/FlateEncode', '/FlateEncode');
	lossy=			sprintf (compr, '/DCTEncode',   '/DCTEncode'  );
	lossy=			[lossy ' -c ".setpdfwrite << /ColorImageDict << /QFactor %g ' ...
					 '/Blend 1 /HSample [%s] /VSample [%s] >> >> setdistillerparams"'];
	
	% Create gs command.
	cmdEnd=			' -sDEVICE=%s -sOutputFile="%s"';					% Essential.
	epsCmd=			'';
	epsCmd=	[epsCmd ' -dSubsetFonts=true -dNOPLATFONTS'];				% Future support?
	epsCmd=	[epsCmd ' -dUseCIEColor=true -dColorConversionStrategy=/UseDeviceIndependentColor'];
	epsCmd=	[epsCmd ' -dProcessColorModel=/%s'];						% Color conversion.
	pdfCmd=	[epsCmd ' -dAntiAliasColorImages=false' cmdEnd];
	epsCmd=	[epsCmd cmdEnd];
	
	% Get file name.
	if((nargin < 1) || isempty(fname) || ~ischar(fname))				% Check file name.
		error('No file name specified.');
	end
	[pathstr, namestr] = fileparts(fname);
	if(isempty(pathstr)), fname= fullfile(cd, namestr);	end
	
	% Get handle.
	fighdl=		get(0, 'CurrentFigure'); % See gcf.						% Get figure handle.
	if((nargin >= 2) && (numel(varargin{1}) == 1) && isnumeric(varargin{1}))
		fighdl=		varargin{1};
		varargin=	{varargin{2:end}};
	end
	if(isempty(fighdl)), error('There is no figure to save!?');	end
	set(fighdl, 'Units', 'centimeters')									% Set paper stuff.
	sz=			get(fighdl, 'Position');
	sz(1:2)=	0;
	set(fighdl, 'PaperUnits', 'centimeters', 'PaperSize', sz(3:4), 'PaperPosition', sz);
	
	% Set up the various devices.
	% Those commented out are not yet supported by gs (nor by savefig).
	% pdf-cmyk works due to the Matlab '-cmyk' export being carried over from eps to pdf.
	device.eps.rgb=		sprintf(epsCmd, 'DeviceRGB',	'epswrite', [fname '.eps']);
	device.jpeg.rgb=	sprintf(cmdEnd,	'jpeg', 					[fname '.jpeg']);
%	device.jpeg.cmyk=	sprintf(cmdEnd,	'jpegcmyk', 				[fname '.jpeg']);
	device.jpeg.gray=	sprintf(cmdEnd,	'jpeggray',					[fname '.jpeg']);
	device.pdf.rgb=		sprintf(pdfCmd, 'DeviceRGB',	'pdfwrite', [fname '.pdf']);
	device.pdf.cmyk=	sprintf(pdfCmd, 'DeviceCMYK',	'pdfwrite', [fname '.pdf']);
	device.pdf.gray=	sprintf(pdfCmd, 'DeviceGray',	'pdfwrite', [fname '.pdf']);
	device.png.rgb=		sprintf(cmdEnd,	'png16m', 					[fname '.png']);
%	device.png.cmyk=	sprintf(cmdEnd,	'png???', 					[fname '.png']);
	device.png.gray=	sprintf(cmdEnd,	'pnggray', 					[fname '.png']);
	device.tiff.rgb=	sprintf(cmdEnd,	'tiff24nc',					[fname '.tiff']);
	device.tiff.cmyk=	sprintf(cmdEnd,	'tiff32nc', 				[fname '.tiff']);
	device.tiff.gray=	sprintf(cmdEnd,	'tiffgray', 				[fname '.tiff']);
	
	% Get options.
	global savefig_defaults;											% Add global defaults.
 	if( iscellstr(savefig_defaults)), varargin=	{savefig_defaults{:}, varargin{:}};
	elseif(ischar(savefig_defaults)), varargin=	{savefig_defaults, varargin{:}};
	end
	varargin=	{'-r300', '-lossless', '-rgb', varargin{:}};			% Add defaults.
	res=		'';
	types=		{};
	fonts=		'false';
	crop=		false;
	for n= 1:length(varargin)											% Read options.
		if(ischar(varargin{n}))
			switch(lower(varargin{n}))
			case {'eps','jpeg','pdf','png','tiff'},		types{end+1}=	lower(varargin{n});
			case '-rgb',				color=	'rgb';	deps= {'-depsc2'};
			case '-cmyk',				color=	'cmyk';	deps= {'-depsc2', '-cmyk'};
			case '-gray',				color=	'gray';	deps= {'-deps2'};
			case '-fonts',				fonts=			'true';
			case '-lossless',			comp=			0;
			case '-crop',				crop=			true;
			case '-dbg',				op_dbg=			true;
			otherwise
				if(regexp(varargin{n}, '^\-r[0-9]+$')), 	 res=  varargin{n};
				elseif(regexp(varargin{n}, '^\-c[0-9.]+$')), comp= str2double(varargin{n}(3:end));
				else	warning('pax:savefig:inputError', 'Unknown option in argument: ''%s''.', varargin{n});
				end
			end
		else
			warning('pax:savefig:inputError', 'Wrong type of argument: ''%s''.', class(varargin{n}));
		end
	end
	types=		unique(types);
	if(isempty(types)), error('No output format given.');	end
	
	if (comp == 0)														% Lossless compression
		gsCompr=		lossless;
	elseif (comp <= 0.1)												% High quality lossy
		gsCompr=		sprintf(lossy, comp, '1 1 1 1', '1 1 1 1');
	else																% Normal lossy
		gsCompr=		sprintf(lossy, comp, '2 1 1 2', '2 1 1 2');
	end
	
	% Generate the gs command.
	switch(computer)													% Get gs command.
		case {'MAC','MACI'},			gs= '/usr/local/bin/gs';
		case {'PCWIN','PCWIN64'},		gs= 'gswin32c.exe';
		otherwise,						gs= 'gs';
	end
	gs=		[gs		' -q -dNOPAUSE -dBATCH -dEPSCrop'];					% Essential.
	gs=		[gs     ' -dPDFSETTINGS=/prepress -dEmbedAllFonts=' fonts];	% Must be first?
	gs=		[gs		' -dUseFlateCompression=true'];						% Useful stuff.
	gs=		[gs		' -dAutoRotatePages=/None'];						% Probably good.
	gs=		[gs		' -dHaveTrueTypes'];								% Probably good.
	gs=		[gs		' ' res];											% Add resolution to cmd.
	
	if(crop && ismember(types, {'eps', 'pdf'}))							% Crop the figure.
		fighdl= do_crop(fighdl);
	end
	
	% Output eps from Matlab.
	renderer=	['-' lower(get(fighdl, 'Renderer'))];					% Use same as in figure.
	if(strcmpi(renderer, '-none')), renderer=	'-painters';	end		% We need a valid renderer.
	print(fighdl, deps{:}, '-noui', renderer, res, [fname '-temp']);	% Output the eps.
	
	% Convert to other formats.
	for n= 1:length(types)												% Output them.
		if(isfield(device.(types{n}), color))
			cmd=		device.(types{n}).(color);						% Colour model exists.
		else
			cmd=		device.(types{n}).rgb;							% Use alternative.
			if(~strcmp(types{n}, 'eps'))	% It works anyways for eps (VERY SHAKY!).
				warning('pax:savefig:deviceError', ...
						'No device for %s using %s. Using rgb instead.', types{n}, color);
			end
		end
		cmp=	lossless;
		if (strcmp(types{n}, 'pdf')),	cmp= gsCompr;		end			% Lossy compr only for pdf.
		if (strcmp(types{n}, 'eps')),	cmp= '';			end			% eps can't use lossless.
		cmd=	sprintf('%s %s %s -f "%s-temp.eps"', gs, cmd, cmp, fname);% Add up.
			status= system(cmd);										% Run Ghostscript.
			if (op_dbg || status), 		display (cmd),		end
	end
	delete([fname '-temp.eps']);										% Clean up.
end


function fig= do_crop(fig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Remove line segments that are outside the view.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	haxes=	findobj(fig, 'Type', 'axes', '-and', 'Tag', '');
	for n=1:length(haxes)
		xl=		get(haxes(n), 'XLim');
		yl=		get(haxes(n), 'YLim');
		lines=	findobj(haxes(n), 'Type', 'line');
		for m=1:length(lines)
			x=				get(lines(m), 'XData');
			y=				get(lines(m), 'YData');
			
			inx=			(xl(1) <= x) & (x <= xl(2));	% Within the x borders.
			iny=			(yl(1) <= y) & (y <= yl(2));	% Within the y borders.
			keep=			inx & iny;						% Within the box.
			
			if(~strcmp(get(lines(m), 'LineStyle'), 'none'))
				crossx=		((x(1:end-1) < xl(1)) & (xl(1) < x(2:end))) ...	% Crossing border x1.
						|	((x(1:end-1) < xl(2)) & (xl(2) < x(2:end))) ...	% Crossing border x2.
						|	((x(1:end-1) > xl(1)) & (xl(1) > x(2:end))) ...	% Crossing border x1.
						|	((x(1:end-1) > xl(2)) & (xl(2) > x(2:end)));	% Crossing border x2.
				crossy=		((y(1:end-1) < yl(1)) & (yl(1) < y(2:end))) ...	% Crossing border y1.
						|	((y(1:end-1) < yl(2)) & (yl(2) < y(2:end))) ...	% Crossing border y2.
						|	((y(1:end-1) > yl(1)) & (yl(1) > y(2:end))) ...	% Crossing border y1.
						|	((y(1:end-1) > yl(2)) & (yl(2) > y(2:end)));	% Crossing border y2.
				crossp=	[(	(crossx & iny(1:end-1) & iny(2:end)) ...	% Crossing a x border within y limits.
						|	(crossy & inx(1:end-1) & inx(2:end)) ...	% Crossing a y border within x limits.
						|	crossx & crossy ...							% Crossing a x and a y border (corner).
						 ),	false ...
						];
				crossp(2:end)=	crossp(2:end) | crossp(1:end-1);		% Add line segment's secont end point.
			
				keep=			keep | crossp;
			end
			set(lines(m), 'XData', x(keep))
			set(lines(m), 'YData', y(keep))
		end
	end
end
