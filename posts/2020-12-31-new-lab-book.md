---
layout: post
title: New open lab notebook prototype
active: lab-book
author: Aaron S. Wolf
date: 2020-12-31
prev:
  post: 2020-12-11-equilibrium-paper-outlines
  title: 'Urgently seeking equilibrium: Manuscript outlines for equilibrium algorithms'
next:
motivation: Given all the distractions of the holiday season, I decided to focus on getting my writing productivity system fully set up. This requires a tight integration of how weekly posts and manuscripts are produced, allowing easy incorporation of posts into growing manuscripts. This post highlights the devleopment work of the past couple weeks.
future-work: The creation of this new pandoc-powered lab-book software is a major step on my journey toward a seemless writing workflow. I look forward to enjoying the fruits of this labor in 2021. Goodbye 2020--and good riddance. Let's make it a productive new year, practicing good habits, and creating as much meaning as possible along the way.
key-points:
  - lab-book posts & manuscripts need different syntax for figures, citations, & document references
  - writing workflow from notebook to manuscript is hindered by differences
  - new lab-book site demonstrates working prototype using identical software (pandoc) for creating lab-book posts and manuscripts
  - new lab-book is hosted in its own dedicated github repo, enabling others to use & shape this developing scientific writing ecosystem
---

## Easing the path from notebook to manuscript
As discussed in a previous post, the *pandoc-scholar* software enables rapid production and sharing of manuscripts in many formats, based on a single markdown input format.
The input format for this lab-book is also markdown, so we should easily transition from a collection of posts to a draft manuscript.
But standing in the way of this theoretically smooth workflow was the fact that the lab-book was built upon github-flavored markdown using the program jekyll as the website generator.
Input files for jekyll and pandoc are similar, but not identical---as always the devil is in the details.
Several key document features use completely different syntax between these two website-site-generation tools; these include figures, literature citations, document section references, figure and table references, and detailed formatting of complex equations.
Converting between these formats introduces unwanted resistance in the writing process---let's fix that.


## A pandoc-powered lab notebook
The most straightforward solution to challenge is using the same underlying software engine, pandoc, to generate both the lab notebook and the eventual manuscript.
Unfortunately, a pandoc-driven website generator does not exist (at least not in a standard and easily tweakable form).
Developers have created some software solutions spanning the range of very simple to overly complex, but none of them are capable of easily delivering the desired a customizable website generator that fully integrates with pandoc-scholar---until now.
You are currently looking at the first working prototype.

My completely remade open lab-notebook is now hosted in its own dedicated public github repository [github.com/aswolf/lab-book](https://github.com/aswolf/lab-book).
The site itself is generated using pandoc driven by a simple Makefile.
It is designed to recreate the look and feel of the original notebook---but by virtue of its pandoc-powered implementation---seemless integrates every feature and syntax detail available in a pandoc-scholar manuscript.
To round out the new experience, I have cleaned up the labbook site, added new links to my daily writing tracker & projects page, and selected an appropriate banner image for the site from my favorite mathematical illustrator M. C. Escher.
