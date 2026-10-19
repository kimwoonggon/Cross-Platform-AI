param([switch]$Open)
$ErrorActionPreference = 'Stop'
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
$vs = & $vswhere -version '[17.0,18.0)' -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath | Select-Object -First 1
if (-not $vs) { throw 'Visual Studio 2022 C++ tools not found.' }
$cmake = Join-Path $vs 'Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe'
$ctest = Join-Path (Split-Path $cmake) 'ctest.exe'
Push-Location $PSScriptRoot
try {
    & $cmake --preset vs2022-x64
    if ($LASTEXITCODE) { throw 'CMake configure failed.' }
    & $cmake --build --preset debug
    if ($LASTEXITCODE) { throw 'Debug build failed.' }
    & $ctest --preset debug
    if ($LASTEXITCODE) { throw 'Starter smoke tests failed.' }
    if ($Open) {
        $solution = Join-Path $PSScriptRoot 'build\vs2022-x64\CrossPlatformAI_08_13.sln'
        Start-Process -FilePath (Join-Path $vs 'Common7\IDE\devenv.exe') -ArgumentList ('"{0}"' -f $solution) -WindowStyle Hidden
    }
} finally { Pop-Location }
