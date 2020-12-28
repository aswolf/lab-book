posts_md = $(wildcard posts/*.md)
posts_html = $(patsubst posts/%.md,docs/%.html,$(posts_md))

.PHONY : all
all : templates images posts

.PHONY : templates
templates : templates/foot.html templates/head.html templates/main.css
	cp -r templates docs/.


.PHONY : images
images : images/*
	cp -r images docs/.

.PHONY : posts
posts : $(posts_html)

# posts : docs/index.html docs/2020-12-11-equilibrium-paper-outlines.html docs/2020-12-18-equilibrium-paper-draft.html

$(posts_html) : $(posts_md)
	pandoc --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<


# docs/index.html : posts/index.md templates/post.html templates/main.css templates/head.html templates/foot.html
# 	pandoc --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o docs/index.html -s posts/index.md
#
#
# docs/2020-12-11-equilibrium-paper-outlines.html : posts/2020-12-11-equilibrium-paper-outlines.md templates/post.html templates/main.css templates/head.html templates/foot.html
# 	pandoc --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o docs/2020-12-11-equilibrium-paper-outlines.html -s posts/2020-12-11-equilibrium-paper-outlines.md
#
# docs/2020-12-18-equilibrium-paper-draft.html : posts/2020-12-18-equilibrium-paper-draft.md templates/post.html templates/main.css templates/head.html templates/foot.html
# 	pandoc --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o docs/2020-12-18-equilibrium-paper-draft.html -s posts/2020-12-18-equilibrium-paper-draft.md
#

.PHONY : clean
clean :
	rm -rf docs/*
