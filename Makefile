BIB_FILE=refs.bib
posts_md = $(wildcard posts/*.md)
posts_html = $(patsubst posts/%.md,docs/%.html,$(posts_md))


post_drafts_md = $(wildcard posts/drafts/*.md)
post_drafts_html = $(patsubst posts/drafts/%.md,docs/drafts/%.html,$(post_drafts_md))

templates = $(wildcard templates/*)
images = $(wildcard images/*)


.PHONY : all
all : templates images docs posts post_drafts
	touch docs/.nojekyll

.PHONY : templates
templates : templates/*
	cp -r templates docs/.
	ln -f -s ../templates docs/drafts/templates


.PHONY : images
images : images/*
	cp -r images docs/.
	ln -f -s ../images docs/drafts/images

.PHONY : docs
docs : posts/docs/*
	cp -r posts/docs docs/.


.PHONY : posts
posts : $(posts_html)


.PHONY : post_drafts
post_drafts : $(post_drafts_html)

.PHONY : draft
draft :
	# basenm = basename $(file) .md
	# echo $(basenm)
	cp -n templates/post-template.md posts/drafts/$(file).md


# site index (uses default pandoc html template)
docs/index.html : posts/index.md $(templates) $(images)
	pandoc --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<


docs/projects.html : posts/projects.md $(templates) $(images)
	pandoc --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<

docs/writing-tracker.html : posts/writing-tracker.md $(templates) $(images)
	pandoc --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<

# all posts use custom post.html pandoc template
docs/%.html : posts/%.md $(templates) $(images)
	pandoc --citeproc --bibliography=$(BIB_FILE) --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<

# all posts use custom post.html pandoc template
docs/drafts/%.html : posts/drafts/%.md $(templates) $(images)
	pandoc --citeproc --bibliography=$(BIB_FILE) --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html  --mathjax -o $@ -s $<

docs/drafts/index.html : posts/drafts/index.md $(templates) $(images)
	pandoc --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<


.PHONY : clean
clean :
	rm -rf docs/*
	mkdir docs/drafts
