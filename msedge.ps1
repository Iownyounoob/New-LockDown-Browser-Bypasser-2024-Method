# Load Selenium module
Import-Module Selenium

# Log function
function LogToFile($message) {
    $LogFilePath = "C:\Users\abcde\OneDrive\Documents\LockdownBrowserProject\log.txt"
    Add-Content -Path $LogFilePath -Value "$message - $(Get-Date)"
}

$edgeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
$edgeOptions.AddArgument("--inprivate")
$driver = Start-SeNewEdge 

$Url = "https://download.respondus.com/lockdown/canvas.php?ID=971615122"
$driver.Navigate().GoToUrl($Url)

$LockDownBrowserProcess = $null
LogToFile "Waiting for LockDown Browser to be launched via rldb:// protocol."

While ($LockDownBrowserProcess -eq $null) {
    $LockDownBrowserProcess = Get-Process -Name "LockDownBrowser" -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2  
}

LogToFile "LockDown Browser detected after rldb:// protocol trigger. Proceeding with DLL injection."

# Step 3: Inject the DLL once LockDown Browser is detected
$DllPath = "C:\Users\abcde\OneDrive\Documents\LockdownBrowserProject\msedge.dll"
$EXEPath = "C:\Users\abcde\OneDrive\Documents\LockdownBrowserProject\msedge.exe"

Try {
    Start-Process -FilePath $EXEPath -ArgumentList @("/d:$DllPath", '"C:\Program Files (x86)\Respondus\LockDown Browser\LockDownBrowser.exe"') -NoNewWindow -Wait
    LogToFile "DLL injection command executed successfully after LockDown Browser launched."
} Catch {
    LogToFile "DLL injection failed. Error: $_"
}

$driver.Quit()

LogToFile "Script execution completed."
