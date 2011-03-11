

Sample visualization results: 
https://github.com/fschwiet/PsakeViz/raw/dc16f13cdccadf5b1e2bc168b27c76b918dee19a/samples/ravendb.default.pdf

Usage: .\VisualizePsakeScript.ps1 [psakeScriptFile] [outputDirectory]


If you want to include psakeviz in your build

  1.  Copy VisualizePsakeScript.ps1 and Graphviz2.26.3/ to your external tools path
  2.  Include a build step that does the following:
  
    task VisualizePsakeScript {
        $location = get-location
        cd .\tools\psakeviz
        & .\VisualizePsakeScript.ps1 $base_dir\default.ps1 $build_dir
        cd $location
    }

  VisualizePsakeScript.ps1 assumes the Graphviz directory is a subdirectory of the working directory, so the task temporarily switches the path to the script directory.


If you want to hack the code,
  Graphviz's documentation can be found here: http://www.graphviz.org/Documentation.php
  The more interesting part of those docs is here: http://www.graphviz.org/doc/info/attrs.html



