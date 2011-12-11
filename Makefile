debug=0
update=1



all: en de

##############################
de: infile=Decoder_changelog
de: outstage1=Decoder_changelog.1
de: outstage2=Decoder_changelog.2
de: outstage3=Decoder_changelog.3
de: log=$(outstage1).log
de: url=http://10.0.2.69/wiki/index.php/$(infile)
de:
	$(parse_changelog)

##############################
en: infile=Encoder_changelog
en: outstage1=Encoder_changelog.1
en: outstage2=Encoder_changelog.2
en: outstage3=Encoder_changelog.3
en: log=$(outstage1).log
en: url=http://10.0.2.69/wiki/index.php/$(infile)
en:
	$(parse_changelog)

##############################
parse_changelog = \
	$(call get_updates,$(url),$(outstage1)); \
	debug=$(debug) perl -w parse_changelog.pl $(outstage1) $(log) >$(outstage2); \
	cat $(outstage2) | $(autoformat) >$(outstage3); \
	cat $(outstage3) > $(infile); \
	rm -f $(outstage2) $(outstage3) $(log)

##############################

autoformat = \
	perl -MText::Autoformat -e \
	'$$tin=""; while(<>){ $$tin .= "$$_"; }; $$tout=autoformat($$tin, {right=>72, all=>1}); print "$$tout\n"'

##############################
get_updates = \
if [ $(update) = 1 ]; \
then \
lynx --width=10000 -dump $(1) > $(2) 2>/dev/null; \
fi
