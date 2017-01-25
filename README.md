# coloc

A docker image that allows to run the colocalization plugins Coloc2 or JACoP in
batch mode.

Use 
 
 docker run -v $(pwd):/fiji/data coloc /bin/sh -c "run-coloc.sh coloc2 5" or
 
 docker run -v $(pwd):/fiji/data coloc /bin/sh -c "run-coloc.sh JACoP 5"

to run Coloc2 or JACoP with a psf width 5.
