export @xbind

struct BondWrapper
	content
end

function Base.show(io::IO, mime::MIME"text/html", b::BondWrapper)
	print(io,
"""<span style="color:#15AA77; vertical-align: top"><strong><code>$(b.content.defines) = </code></strong></span>""")
	Base.show(io, mime, b.content)
end

macro xbind(args...)
	esc(quote
		let
			bond = @bind $(args...)
			$BondWrapper(bond)
		end
	end)
end

