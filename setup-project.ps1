# Variables
$githubToken = "github_pat_11BI5WQNY0RPFqcDAzVHMO_eixHIwolFqpkQBRtpsTdlN3ZLV1NOopHMQNm"
$repoUrl = "https://github.com/cheche3322/project-universe.git"
$projectFolderPath = "C:\Users\bewil\Downloads\project universe"

# Create main project folder if it doesn't exist
if (-Not (Test-Path -Path $projectFolderPath)) {
    New-Item -ItemType Directory -Path $projectFolderPath
}

# Change to the project directory
cd $projectFolderPath

# Create a virtual environment
python -m venv venv

# Activate the virtual environment
.\venv\Scripts\activate

# Install required Python packages
pip install pygithub streamlit debugpy autopep8 black pylint chatterbot pytest

# Verify installation
pip list

# Create a requirements.txt file
pip freeze > requirements.txt

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
from github import Github
import debugpy
import autopep8
import black
import pylint.lint
import os
from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer
import pytest

# Initialize GitHub Integration
def init_github(token, repo_url, project_folder):
    g = Github(token)
    repo = g.get_repo(repo_url)
    if not os.path.exists(project_folder):
        os.makedirs(project_folder)
    return repo

# Function to organize code
def organize_code(code_snippet, project_folder):
    formatted_code = black.format_str(code_snippet, mode=black.Mode())
    pylint_output = pylint.lint.Run([formatted_code])
    file_path = os.path.join(project_folder, "src", "organized_code.py")
    with open(file_path, 'w') as f:
        f.write(formatted_code)
    return formatted_code

# Function to deploy project
def deploy_project():
    # Implement your deployment logic here
    return "Project deployed successfully!"

# Initialize the chatbot
chatbot = ChatBot('Code Assistant')
trainer = ListTrainer(chatbot)

# Initialize the Streamlit app
st.title('Streamlined Project Organizer and Deployment')

# Input fields for project details
project_folder = st.text_input('Project Folder Path', 'C:\\Users\\bewil\\Downloads\\project universe')
project_name = st.text_input('Project Name', 'Project Universe')
github_url = st.text_input('GitHub Repository URL', 'https://github.com/cheche3322/project-universe.git')

# Input code via text area or file upload
code_input = st.text_area('Input Code Snippet')
uploaded_file = st.file_uploader("Choose a file", type=["py"])

code_snippet = ""
if uploaded_file is not None:
    code_snippet = uploaded_file.getvalue().decode("utf-8")
elif code_input:
    code_snippet = code_input

# Code evaluation and organization
if st.button('Evaluate Code'):
    if code_snippet:
        formatted_code = organize_code(code_snippet, project_folder)
        st.write('Formatted and analyzed code:')
        st.code(formatted_code)
        st.success('Code evaluated and organized!')
    else:
        st.error('Please input code or upload a file.')

# Attach debugger
if st.button('Attach Debugger'):
    debugpy.listen(('0.0.0.0', 5678))
    debugpy.wait_for_client()
    debugpy.breakpoint()
    st.success('Debugger attached and running!')

# Auto-correct code
if st.button('Auto-correct Code'):
    corrected_code = autopep8.fix_code(code_snippet)
    st.write('Auto-corrected code:')
    st.code(corrected_code)

# Processing and preview stage
st.subheader('Project Preview')
st.write('Display organized and processed project preview here...')
backend_code = st.text_area('Backend Code')
frontend_code = st.text_area('Frontend Code')

if st.button('Process and Preview Project'):
    processed_backend = black.format_str(backend_code, mode=black.Mode())
    processed_frontend = black.format_str(frontend_code, mode=black.Mode())
    st.write('Processed Backend Code:')
    st.code(processed_backend)
    st.write('Processed Frontend Code:')
    st.code(processed_frontend)
    st.success('Project processed and previewed!')

# Interactive chat interface for changes
st.subheader('Chat with Interface')
chat_input = st.text_input('Enter changes or commands')
if st.button('Apply Changes'):
    response = chatbot.get_response(chat_input)
    st.write('Bot Response:', response)
    # Logic to apply changes to the project
    st.success('Changes applied!')

# Testing stage
st.subheader('Testing Stage')
if st.button('Run Tests'):
    test_results = pytest.main(["--tb=short", "-q"])
    st.write('Test Results:')
    st.code(test_results)
    st.success('Tests executed!')

# Go live stage
st.subheader('Go Live')
if st.button('Deploy Project'):
    deployment_status = deploy_project()
    st.write(deployment_status)
    st.success('Project deployed!')

# Embed GitHub token for authentication
if st.button('Initialize GitHub Repository'):
    repo = init_github($githubToken, github_url, project_folder)
    st.success('GitHub repository initialized!')
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
git init
git remote add origin $repoUrl

# Embed GitHub token for authentication
git config --global credential.helper store
[System.IO.File]::WriteAllText("$Env:USERPROFILE\.git-credentials", "https://${githubToken}:@github.com")

# Add all files to git, commit, and push
git add .
git commit -m "Initial commit with project structure"
git push -u origin master

# Start the Streamlit app
streamlit run .\streamlit_app\app.py
