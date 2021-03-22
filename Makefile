.PHONY: s
serve:
	jekyll serve --watch

.PHONY: install
install:
	bundle update

.PHONY: d
d:
	jekyll draft

.PHONY: p
p:
	jekyll public
