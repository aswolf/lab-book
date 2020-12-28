
.PHONY : posts
posts : docs/2020-12-11-equilibrium-paper-outlines.html docs/2020-12-18-equilibrium-paper-draft.html

docs/2020-12-11-equilibrium-paper-outlines.html : posts/2020-12-11-equilibrium-paper-outlines.md templates/post.html templates/main.css templates/head.html templatex/foot.html
	pandoc --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o docs/2020-12-11-equilibrium-paper-outlines.html -s posts/2020-12-11-equilibrium-paper-outlines.md

docs/2020-12-18-equilibrium-paper-draft.html : posts/2020-12-18-equilibrium-paper-draft.md templates/post.html templates/main.css templates/head.html templatex/foot.html
	pandoc --template=templates/post.html --css templates/main.css -t html5 -B templates/head.html -A templates/foot.html --mathjax -o docs/2020-12-18-equilibrium-paper-draft.html -s posts/2020-12-18-equilibrium-paper-draft.md


.PHONY : clean
clean :
	rm -rf docs/*
