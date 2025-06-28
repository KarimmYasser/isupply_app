flutter build windows --release

# Define the source directory for the built Windows application
$SourceDir = "build\windows\x64\runner\Release"

# Define the desired name for the destination folder in the project root
$DestinationFolderName = "executable_app"
$DestinationDir = ".\$DestinationFolderName"

# Create the destination directory if it doesn't already exist.
# The -Force parameter ensures it's created even if parent directories don't exist.
New-Item -ItemType Directory -Force -Path $DestinationDir

# Copy all contents from the source directory to the new destination directory.
# -Recurse ensures that all subfolders and files are copied.
# -Force allows overwriting existing files without prompt.
Copy-Item "$SourceDir\*" -Destination $DestinationDir -Recurse -Force

Write-Output "✅ Windows application copied to '$DestinationDir'."
Write-Output "To run your app, navigate to that folder and launch 'isupply_app.exe'."