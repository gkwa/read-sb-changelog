# usage: make Encoder
# or
# usage: make Decoder
# or
# usage: make --debug=basic --always-make Decoder

wiki_changelog_baseurl=http://10.0.2.69/wiki/index.php

%:
	$(MAKE) $(@)_changelog.html.parsed.tidy

%.html.parsed.tidy : %.html.parsed ;
	tidy \
		--force-output true \
		-asxhtml \
		--tidy-mark no \
		--doctype strict \
		-indent \
		-quiet \
		-wrap 99999999 \
		-clean \
		-f $@.err \
		-output $@ \
		$^

%.html.parsed : %.html ;
	perl -w parse_changelog.pl --inputfile=$< --outputfile=$@

%_changelog.html: url=$(wiki_changelog_baseurl)/$(subst .html,,$@)
%_changelog.html:
	curl --silent -o$@ $(url)

.PRECIOUS: %_changelog.html %.html.parsed

# lynx -nonumbers -width=100000 -dump Decoder_changelog.html >Decoder_changelog.lynx

clean:
	rm -f *.html *.parsed *.tidy *.tidy.err
.PHONY: clean
