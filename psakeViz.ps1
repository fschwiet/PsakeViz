
properties {

    $psakeScriptToDraw = ".\psakeViz.ps1"
    $outputDirectory = ".\output\"
}

task default -depends Instructions, Draw

task Instructions -precondition { $psakeScriptToDraw -eq ".\psakeViz.ps1" } {
    write-host
    "You can specify any psake script to be drawn as the first parameter to runme.ps1" | write-host -fore green
    write-host
}

task Draw {

    $tasks = @{};

    function properties {
    }

    function task {
        param ($name, $depends = @())
        
        $tasks[$name] = @{
            name = $name
            depends = $depends
        };
    }
    
    & $psakeScriptToDraw
    
    $weights = @{};
    
    function GetTaskWeight ($task) {

        if ($weights[$task.name] -ne $null) {
            return $weights[$task.name];
        }
        
        $sum = 0;
        
        if ($task.depends.length) {
        
            foreach($dependency in $task.depends) {
            
                $sum += 1;
                $sum += GetTaskWeight $tasks[$dependency]
            }
        }
        
        return $sum;
    }

    $tasks.GetEnumerator() | % { $weights[$_.name] = GetTaskWeight $_.value } 
    
    $weights | format-list
    
    

    
}


