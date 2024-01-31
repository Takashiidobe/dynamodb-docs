SOURCE_DOCS := $(shell find src -type f -name "*.md")

HTML_FILES=$(SOURCE_DOCS:src/%.md=site/%.html)

all: html copy_files
	./convert-html.sh
	firefox site/index.html

deploy: html copy_files build_index
	ntl deploy --prod

html: mkdirs $(HTML_FILES)

site/%.html: src/%.md _template.html.template
	pandoc -f markdown+fenced_divs -s $< -o $@ --table-of-contents --template ./_template.html.template

build_index: $(SOURCE_DOCS)
	pagefind --source site

copy_files:
	cp styles.css site/

clean:
	rm -r site/**/*.html

.PHONY: mkdirs
mkdirs:
	rsync -a --include='*/' \
	--include="*.png" \
	--include="*.jpg" \
	--include="*.jpeg" \
	--exclude='*' src/ site/
