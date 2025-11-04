*** Settings ***
Library    ../libraries/GitOperations.py
Library    OperatingSystem
Library    DateTime

*** Variables ***
${text_path}    ${CURDIR}/../testdata/GitOp.txt

*** Test Cases ***
Open, read, write, save, and commit text file
    ${currDateTime}    Get Current Date
    Append To File    ${text_path}    Appended value at: ${currDateTime}

    
