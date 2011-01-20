
properties {

    $psakeScriptToDraw = (gi ".\psakeViz.ps1")
    $outputDirectory = (gi ".\output\")
}

task default -depends Instructions, Draw

task Instructions -precondition { $psakeScriptToDraw -eq ".\psakeViz.ps1" } {

    "`
    You can specify any psake script to be drawn as the first parameter to runme.ps1`
" | write-host -fore green

}

task Draw {

    $tasks = @{};

    function Properties {
    }

    function Task {
        
        param(
            [Parameter(Position=0,Mandatory=1)]
            [string]$name = $null,

            [Parameter(Position=1,Mandatory=0)]
            [scriptblock]$action = $null,

            [Parameter(Position=2,Mandatory=0)]
            [scriptblock]$preaction = $null,

            [Parameter(Position=3,Mandatory=0)]
            [scriptblock]$postaction = $null,

            [Parameter(Position=4,Mandatory=0)]
            [scriptblock]$precondition = {$true},

            [Parameter(Position=5,Mandatory=0)]
            [scriptblock]$postcondition = {$true},

            [Parameter(Position=6,Mandatory=0)]
            [switch]$continueOnError = $false,

            [Parameter(Position=7,Mandatory=0)]
            [string[]]$depends = @(),

            [Parameter(Position=8,Mandatory=0)]
            [string]$description = $null
        )        
        
        $tasks[$name] = @{
            name = $name;
            depends = $depends;
        };
    }
    
    $psakeScriptFileinfo = (New-Object -TypeName "System.IO.FileInfo" -ArgumentList $psakeScriptToDraw)
    
    "switch to " + $psakeScriptFileinfo.DirectoryName
    $originalLocation = get-location
    set-location $psakeScriptFileinfo.Directory
    $global:t = $psakeScriptFileinfo
    
    try {
    
        & $psakeScriptToDraw
    } finally {
        set-location $originalLocation
    }
    
    $global:tasks = $tasks
    

    $result = "`
digraph {`
    graph [rankdir = ""LR""];"


    foreach($name in $tasks.keys) {
        $task = $tasks[$name];
        
        $line = "`n    $name [ shape=""record"", label=<$name> ] ";
    
        foreach($dependency in $task.depends) {
            $line += " $name -> $dependency;"
        }
        
        $result += $line
    }
    
    $result += "`n}`n"
    $result
    
    
    $outputFilename = $psakeScriptFileinfo.BaseName;
    
    if (-not (test-path $outputDirectory)) {
        $null = mkdir $outputDirectory
    }
    
    $result | & 'C:\Program Files (x86)\Graphviz2.26.3\bin\dot.exe' -Tjpg -o (join-path $outputDirectory "$outputFilename.jpg")
    $result | & 'C:\Program Files (x86)\Graphviz2.26.3\bin\dot.exe' -Tpdf -o (join-path $outputDirectory "$outputFilename.pdf")
}


