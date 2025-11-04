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

    commit_and_push     GitOp.txt    version_3_dev

Write to output folder
    List Directory    ${CURDIR}
