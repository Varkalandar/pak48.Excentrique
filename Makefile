# Just run
#   make clean all archives
# to get fresh and ready to deploy .tbz2 and .zip archives

MAKEOBJ ?= ./makeobj

DESTDIR  ?= .
PAKDIR   ?= $(DESTDIR)/pak48.Excentrique
ADDONDIR ?= $(DESTDIR)/addons/pak48.Excentrique
PAKVERSION ?= 19
DESTFILE ?= pak48-excentrique_v0$(PAKVERSION)
INSTALL ?= ../../simutrans/pak48.Excentrique

OUTSIDE :=
OUTSIDE += ground

DIRS48 :=
DIRS48 += city
DIRS48 += citycar
DIRS48 += decoration
DIRS48 += extra
DIRS48 += goods
DIRS48 += industry/music
# DIRS48 += industry/weather
DIRS48 += menus
DIRS48 += misc
DIRS48 += pedestrians
DIRS48 += powerline
DIRS48 += sights
DIRS48 += tree
DIRS48 += treelike
DIRS48 += vehicles_rail
DIRS48 += vehicles_road
DIRS48 += way_misc
DIRS48 += way_rail
DIRS48 += way_road

DIRS64 += skin

DIRS128 :=
DIRS128 += big_logo

ADDON_DIRS48 :=
ADDON_DIRS48 += factory_food

DIRS := $(OUTSIDE) $(DIRS48) $(DIRS64) $(DIRS128)
ADDON_DIRS := $(ADDON_DIRS48)


.PHONY: $(DIRS) $(ADDON_DIRS48) copy tar zip

all: version copy $(DIRS) zip

archives: tar zip

tar: $(DESTFILE).tbz2
zip: $(DESTFILE).zip


release: clean copy $(DIRS)
	mkdir -p $(INSTALL)
	rm -rf $(INSTALL)/*
	cp index.png $(INSTALL)
	mv $(PAKDIR)/* $(INSTALL)


$(DESTFILE).tbz2: $(PAKDIR)
	@echo "===> TAR $@"
	@tar cjf $@ $(DESTDIR)

$(DESTFILE).zip: $(PAKDIR)
	@echo "===> ZIP $@"
	@zip -rq $@ $(PAKDIR)

copy:
	@echo "===> COPY"
	@mkdir -p $(PAKDIR)/sound $(PAKDIR)/text $(PAKDIR)/config $(PAKDIR)/scenario
	@cp -p config/* $(PAKDIR)/config
	@cp -p text/* $(PAKDIR)/text

$(DIRS48):
	@echo "===> PAK48 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK48 $(PAKDIR)/ $@/ > /dev/null

$(DIRS64):
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK64 $(PAKDIR)/ $@/ > /dev/null

$(DIRS128):
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 $(PAKDIR)/ $@/ > /dev/null

version:
	@echo "===> Version"
	@mkdir -p $(PAKDIR)
	@rm -f ground/outside.dat
	@echo "Obj=ground" >ground/outside.dat
	@echo "Name=Outside" >>ground/outside.dat
	@echo "copyright=pak48.Excentrique v0.$(PAKVERSION)" >>ground/outside.dat
	@echo "Image[0][0]=hjm-starpatch.0.0" >>ground/outside.dat
	@echo "----------" >>ground/outside.dat

$(OUTSIDE):
	@$(MAKEOBJ) PAK48 $(PAKDIR)/ $@/ > /dev/null

clean:
	@echo "===> CLEAN"
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip

addons: 	clean copy_addons $(ADDON_DIRS48)

copy_addons:
	@echo "===> COPY"
	@mkdir  -p $(ADDONDIR)

$(ADDON_DIRS48):
	@echo "===> PAK64 $@"
	@mkdir -p $(ADDONDIR)
	@$(MAKEOBJ) quiet PAK48 $(ADDONDIR)/ $@/ > /dev/null
