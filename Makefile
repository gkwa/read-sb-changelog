# usage: make Encoder
# or
# usage: make Decoder
# or
# usage: make --debug=basic --always-make Decoder

wiki_changelog_baseurl=http://10.0.2.69/wiki/index.php

all: encoder decoder

decoder:
	$(MAKE) Decoder_changelog.html.parsed.tidy
encoder:
	$(MAKE) Encoder_changelog.html.parsed.tidy

TIDY_SW =
TIDY_SW += --force-output true
TIDY_SW += --tidy-mark no
TIDY_SW += --doctype strict
TIDY_SW += -indent
TIDY_SW += -asxhtml
TIDY_SW += -quiet
TIDY_SW += -wrap 99999999
TIDY_SW += -clean
TIDY_SW += -f $@.err

%.html.parsed.tidy : %.html.parsed ;
	tidy $(TIDY_SW) -output $@ $^

%.html.parsed : %.html ;
	perl -w parse_changelog.pl --inputfile=$< --outputfile=$@

%_changelog.html: url=$(wiki_changelog_baseurl)/$(subst .html,,$@)
%_changelog.html:
	curl --silent -o$@ $(url)

.PRECIOUS: %_changelog.html %.html.parsed

test:
	rm -f Encoder_changelog.html.parsed.tidy
	$(MAKE) Encoder

# lynx -nonumbers -width=100000 -dump Decoder_changelog.html >Decoder_changelog.lynx

clean:
	rm -f *.html *.parsed *.tidy *.tidy.err
.PHONY: clean
