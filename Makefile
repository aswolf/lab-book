BIB_FILE=refs.bib

##################
# Find all pages #
##################

# Create pattern for index section pages either wildcard w/ substitution or using site structure (separating posts into separate directory)
posts_md = $(wildcard posts/*.md)
posts_html = $(patsubst posts/%.md,docs/%.html,$(posts_md))


post_drafts_md = $(wildcard posts/drafts/*.md)
post_drafts_html = $(patsubst posts/drafts/%.md,docs/drafts/%.html,$(post_drafts_md))

templates = $(wildcard templates/*)
images = $(wildcard images/*)


##################
# PANDOC OPTIONS #
##################

ifndef PANDOC_WRITER_OPTIONS
# PANDOC_WRITER_OPTIONS  = --standalone
# PANDOC_WRITER_OPTIONS += --citeproc
PANDOC_WRITER_OPTIONS  = --citeproc
ifdef BIB_FILE
# PANDOC_WRITER_OPTIONS += --metadata "bibliography:$(BIB_FILE)"
PANDOC_WRITER_OPTIONS += --bibliography=$(BIB_FILE)
endif
endif


PANDOC_WRITER_OPTIONS := --filter pandoc-xnos $(PANDOC_WRITER_OPTIONS)
# PANDOC_WRITER_OPTIONS := --number-sections $(PANDOC_WRITER_OPTIONS)

INDEX_CSS_HTML_OPTIONS = --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax

POST_CSS_HTML_OPTIONS = --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax


.PHONY : all
all : templates images figs docs posts post_drafts
	touch docs/.nojekyll

.PHONY : templates
templates : templates/*
	cp -r templates docs/.
	ln -f -s ../templates docs/drafts/templates


.PHONY : images
images : images/*
	cp -r images docs/.
	ln -f -s ../images docs/drafts/images

.PHONY : figs
figs : posts/figs/*
	cp -r posts/figs docs/.
	# cp -r posts/drafts/figs docs/drafts/.

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

.PHONY : preview
preview :
	open 'http://[::]:8080/lab-book'; python -m http.server --cgi 8080

.PHONY : preview-drafts
preview-drafts :
	open 'http://[::]:8080/lab-book/drafts/'; python -m http.server --cgi 8080

.PHONY : export
export :
	pandoc --citeproc --bibliography=$(BIB_FILE) -t docx --mathjax -o export/$(file).docx -s posts/$(file).md


##############
# Main Pages #
##############

# Need to generalize to any section index page (possibly by separating from posts in directory structure?)

# site index (uses default pandoc html template)
docs/index.html : posts/index.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

docs/projects.html : posts/projects.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

docs/writing-tracker.html : posts/writing-tracker.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

docs/writing-workshop.html : posts/writing-workshop.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

# Temporary location
docs/workshop-syllabus.html : posts/workshop-syllabus.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

docs/workshop-handout1.html : posts/workshop-handout1.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

docs/workshop-handout2.html : posts/workshop-handout2.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

#########
# Posts #
#########
# --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax

# all posts use custom post.html pandoc template
docs/%.html : posts/%.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(POST_CSS_HTML_OPTIONS) -o $@ -s $<
	# pandoc --citeproc --bibliography=$(BIB_FILE) --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o $@ -s $<

##########
# Drafts #
##########
# --citeproc --bibliography=$(BIB_FILE) --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html  --mathjax

# all posts use custom post.html pandoc template
docs/drafts/%.html : posts/drafts/%.md $(templates) $(images)
	pandoc $(PANDOC_WRITER_OPTIONS) $(POST_CSS_HTML_OPTIONS) -o $@ -s $<

# --template=templates/index-template.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax
docs/drafts/index.html : posts/drafts/index.md $(templates) $(images)
	pandoc  $(PANDOC_WRITER_OPTIONS) $(INDEX_CSS_HTML_OPTIONS) -o $@ -s $<

###########
# Cleanup #
###########

.PHONY : clean
clean :
	rm -rf docs/*
	mkdir docs/drafts
