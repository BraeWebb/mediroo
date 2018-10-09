.PHONY: dist

DIST := static/dist/

all: dist

dist:
	mkdir -p $(DIST)
	cd $(DIST) && git clone https://github.com/Semantic-Org/Semantic-UI-CSS semantic-ui
	cd $(DIST) && mkdir jquery
	cd $(DIST) && curl https://code.jquery.com/jquery-3.3.1.min.js -o jquery/jquery.min.js
	pip3 install google-cloud-firestore

clean:
	rm -r $(DIST)
