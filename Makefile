posts_md = $(wildcard posts/*.md)
posts_html = $(patsubst posts/%.md,docs/%.html,$(posts_md))

templates = $(wildcard templates/*)
images = $(wildcard images/*)


.PHONY : all
all : templates images docs posts
	touch docs/.nojekyll

.PHONY : templates
templates : templates/*
	cp -r templates docs/.


.PHONY : images
images : images/*
	cp -r images docs/.

.PHONY : docs
docs : posts/docs/*
	cp -r posts/docs docs/.


.PHONY : posts
posts : $(posts_html)



# site index (uses default pandoc html template)
docs/index.html : posts/index.md $(templates) $(images)
	pandoc --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<

# all posts use custom post.html pandoc template
docs/%.html : posts/%.md $(templates) $(images)
	pandoc --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<



.PHONY : clean
clean :
	rm -rf docs/*
