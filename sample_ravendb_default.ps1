
#
#  This sample psake script is included so I can quickly
#  verify psakeviz.  The original tasks were removed.  If
#  you would like to see the original script, its at
#  https://github.com/ravendb/ravendb/blob/master/default.ps1
#

properties {
}
include .\psake_ext.ps1

task default -depends OpenSource,Release

task Verify40 {
}


task Clean {
}

task Init -depends Verify40, Clean {
}

task Compile -depends Init {
}

task Test -depends Compile{
}

task TestSilverlight {
}

task ReleaseNoTests -depends OpenSource,DoRelease {
}

task Commercial {
}

task Unstable {
}

task OpenSource {
}

task Release -depends Test,TestSilverlight,DoRelease { 
}

task CopySamples {
}

task CreateOutpuDirectories -depends CleanOutputDirectory {
}

task CleanOutputDirectory { 
}

task CopyEmbeddedClient { 
}

task CopySilverlight{ 
}

task CopySmuggler { 
}

task CopyClient {
}

task CopyClient35 {
}

task CopyWeb { 
}

task CopyBundles {
}

task CopyServer {
}


task CreateDocs {
}

task CopyDocFiles -depends CreateDocs {
}

task ZipOutput {
}

task ResetBuildArtifcats {
}

task DoRelease -depends Compile, `
	CleanOutputDirectory,`
	CreateOutpuDirectories, `
	CopyEmbeddedClient, `
	CopySmuggler, `
	CopyClient, `
	CopySilverlight, `
	CopyClient35, `
	CopyWeb, `
	CopyBundles, `
	CopyServer, `
	CopyDocFiles, `
	CopySamples, `
	ZipOutput, `
	CreateNugetPackage, `
	ResetBuildArtifcats {	
}


task Upload -depends DoRelease {
}

task UploadCommercial -depends Commercial, DoRelease, Upload {
}	

task UploadOpenSource -depends OpenSource, DoRelease, Upload {
}	

task UploadUnstable -depends Unstable, DoRelease, Upload {
}	

task CreateNugetPackage {
}