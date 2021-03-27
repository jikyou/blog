.PHONY: s
serve:
	jekyll serve -w

.PHONY: wiki
wiki:
	tiddlywiki ./wiki --server

.PHONY: install
install:
	bundle update
	npm install -g tiddlywiki

.PHONY: build
build: jekyllbuild wikibuild

.PHONY: jekyllbuild
jekyllbuild:
	jekyll build -d

.PHONY: wikibuild
wikibuild:
	tiddlywiki ./wiki \
	    --verbose \
	    --version \
	    --output ./output/wiki \
	    --build static favicon index

.PHONY: d
d:
	jekyll draft

.PHONY: p
p:
	jekyll public
