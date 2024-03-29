#!/usr/bin/env perl
$latex            = 'pdflatex -shell-escape -synctex=1 -halt-on-error -kanji=utf-8';
#$latex            = 'platex -interaction=nonstopmode -kanji=utf-8 %O %S';
$latex_silent     = 'pdflatex -shell-escape -synctex=1 -halt-on-error -interaction=batchmode';
$bibtex           = 'pbibtex';
$dvipdf           = 'dvipdfmx %O -o %D %S';
$makeindex        = 'mendex %O -o %D %S';
$max_repeat       = 5;
$pdf_mode     = 3; # generates pdf via dvipdfmx

# Prevent latexmk from removing PDF after typeset.
# This enables Skim to chase the update in PDF automatically.
$pvc_view_file_via_temporary = 0;

# Use Skim as a previewer
$pdf_previewer    = "xdg-open";
