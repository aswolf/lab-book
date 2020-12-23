# lab-book
Open Lab Notebook for Aaron S. Wolf

* from top-level dir

cp -r templates docs/.
cp -r images docs/.

* from posts directory
pandoc --css ../templates/main.css -t html5 -B ../templates/head.html -A ../templates/foot.html --mathjax -o 2020-11-05-MEXQAL.html -s 2020-11-05-MEXQAL.md

pandoc --css ../templates/main.css -t html5 -B ../templates/head.html -A ../templates/foot.html --mathjax -o index.html -s index.md

pandoc --css ../templates/main.css -t html5 -B ../templates/head.html -A ../templates/foot.html --mathjax -o 2020-12-18-equilibrium-paper-draft.html -s 2020-12-18-equilibrium-paper-draft.md

pandoc --template=../templates/pandoc-template.html --css ../templates/main.css -t html5 -B ../templates/head.html -A ../templates/foot.html --mathjax -o 2020-12-18-equilibrium-paper-draft.html -s 2020-12-18-equilibrium-paper-draft.md
