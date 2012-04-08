
param($psakeScriptToDraw, $outputDirectory = ".\output\")

function VisualizePSakeScript($sourceDirectory, $psakeScriptToDraw, $outputDirectory) {

    $psakeScriptFileinfo = (New-Object -TypeName "System.IO.FileInfo" -ArgumentList (gi $psakeScriptToDraw))

    $tasks = LoadTasks $psakeScriptFileinfo
    
    $global:tasks = $tasks
    
	$result = DrawTasks $tasks
    
    $outputFilename = $psakeScriptFileinfo.BaseName;
    
    if (-not (test-path $outputDirectory)) {
        $null = mkdir $outputDirectory
    }
    
    $result | & "$sourceDirectory\Graphviz2.26.3\dot.exe" -Tjpg -o (join-path $outputDirectory "$outputFilename.jpg")
    $result | & "$sourceDirectory\Graphviz2.26.3\dot.exe" -Tpdf -o (join-path $outputDirectory "$outputFilename.pdf")
	
	$result
}

function DrawTasks {

	$nodes = @()
	$edges = @()

    $ks = @($tasks.keys);
    [Array]::reverse($ks);

    foreach($name in $ks) {

        $task = $tasks[$name];
        
		$nodes += $name;

		$dependencies = @($task.depends)

        foreach($dependency in $dependencies) {
			$edges += @{ head = $name; tail = $dependency}
		}
    }
	
    $result = "`
digraph {`
    graph [rank=""source""; rankdir = ""LR""; ordering=out];"

	foreach($node in $nodes) {
		$result += "`n    $node [ shape=""record"", label=<$node> ]"
	}
	
	foreach($edge in $edges) {
		$result += "`n    $($edge.head) -> $($edge.tail)"
	}
    
    $result += "`n}`n"
    $result
}

function LoadTasks([System.IO.FileInfo] $psakeScript) {

    $tasks = @{};

    function Include {
	}

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
		
		$name = $name.Replace("-", "");
        
        $tasks[$name] = @{
            name = $name
            depends = $depends | % { $_.Replace("-", "") };
        };
    }
	
	function FormatTaskName {
	}
    
    $originalLocation = get-location
    set-location $psakeScript.Directory
    
    try {
    
        & (gi $psakeScript)
    } finally {
        set-location $originalLocation
    }
    
	$tasks
}


VisualizePSakeScript "." $psakeScriptToDraw $outputDirectory 

