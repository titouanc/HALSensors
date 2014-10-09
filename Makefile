
FILES = index.html halstyle.css halsensors.js

HAML = haml
SASS = sass
COFFEE = coffee
DEST = ~/www

all: ${FILES}
deploy: $(addprefix ${DEST}/,${FILES})
clean:
	rm -f ${FILES}

.PHONY: all deploy clean

${DEST}/%: %
	cp $< $@

%.html: %.haml
	${HAML} $< > $@ || rm -f $@

%.css: %.sass
	${SASS} -t expanded $< > $@ || rm -f $@

%.js: %.coffee
	${COFFEE} -c $< || rm -f $@
