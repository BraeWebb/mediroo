.PHONY: dist

DIST := static/dist/

all: dist

dist:
	mkdir -p $(DIST)
	cd $(DIST) && git clone https://github.com/Semantic-Org/Semantic-UI-CSS semantic-ui || true
	cd $(DIST) && mkdir -p jquery
	cd $(DIST) && curl https://code.jquery.com/jquery-3.3.1.min.js -o jquery/jquery.min.js
	cd $(DIST) && mkdir -p moment
	cd $(DIST) && curl https://momentjs.com/downloads/moment.js -o moment/moment.js

clean:
	rm -r $(DIST)
