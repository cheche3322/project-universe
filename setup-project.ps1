# Variables
$githubToken = "github_pat_11BI5WQNY0RPFqcDAzVHMO_eixHIwolFqpkQBRtpsTdlN3ZLV1NOopHMQNm"
$repoUrl = "https://github.com/cheche3322/project-universe.git"
$projectFolderPath = "C:\Users\bewil\Downloads\project universe"

# Create main project folder if it doesn't exist
if (-Not (Test-Path -Path $projectFolderPath)) {
    New-Item -ItemType Directory -Path $projectFolderPath
}

# Function to create subfolders and files
function Create-ProjectStructure {
    param (
        [string]$basePath
    )

    # Define the structure
    $structure = @{
        "src" = @(
            "main.py"
        )
        "tests" = @(
            "test_main.py"
        )
        "docs" = @(
            "README.md"
        )
        "streamlit_app" = @(
            "app.py"
        )
    }

    foreach ($folder in $structure.Keys) {
        $folderPath = Join-Path -Path $basePath -ChildPath $folder
        if (-Not (Test-Path -Path $folderPath)) {
            New-Item -ItemType Directory -Path $folderPath
        }

        foreach ($file in $structure[$folder]) {
            $filePath = Join-Path -Path $folderPath -ChildPath $file
            if (-Not (Test-Path -Path $filePath)) {
                New-Item -ItemType File -Path $filePath
                # Add content to each file based on its purpose
                switch ($file) {
                    "main.py" {
                        Set-Content -Path $filePath -Value @"
import streamlit as st

def main():
    st.title('Streamlined Project Organizer and Deployment')
    # Add other Streamlit functionalities here

if __name__ == "__main__":
    main()
"@
                    }
                    "test_main.py" {
                        Set-Content -Path $filePath -Value @"
import pytest

def test_example():
    assert True
"@
                    }
                    "README.md" {
                        Set-Content -Path $filePath -Value @"
# Project Universe
This is the README file for the Project Universe.
"@
                    }
                    "app.py" {
                        Set-Content -Path $filePath -Value @"
import streamlit as st

st.title('Streamlit Application')
st.write('This is a sample Streamlit app.')
"@
                    }
                }
            }
        }
    }
}

# Create the project structure
Create-ProjectStructure -basePath $projectFolderPath

# Initialize Git repository and add remote
cd $projectFolderPath
git init
git remote add origin $repoUrl

# Embed GitHub token for authentication
git config --global credential.helper store
[System.IO.File]::WriteAllText("$Env:USERPROFILE\.git-credentials", "https://$githubToken:@github.com")

# Add all files to git, commit, and push
git add .
git commit -m "Initial commit with project structure"
git push -u origin master

# Start the Streamlit app
streamlit run .\streamlit_app\app.py
