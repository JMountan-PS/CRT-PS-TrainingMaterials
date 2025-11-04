*** Settings ***
Library    ../libraries/GitOperations.py
Resource   ../resources/excelWrite.resource
Library    OperatingSystem
Library    Collections
Library    DateTime

*** Variables ***
${text_path}    ${CURDIR}/../testdata/GitOp.txt
${output_path}    ${CURDIR}/../../output

*** Test Cases ***
Open, read, write, save, and commit text file
    ${currDateTime}    Get Current Date
    Append To File    ${text_path}    Appended value at: ${currDateTime}

    commit_and_push     GitOp.txt    version_3_dev

Write New Excel to output folder
    List Directory    ${CURDIR}/../../output
    
    Create New Excel Document-copado    accountsData

    @{headers}                        Create List    Name    Email    Phone

    Write Single Row-copado           1              ${headers}
    
    ${dataLine1}                      Create List    ACME    ACME@company.com    1112223334
    ${dataLine2}                      Create List    Growmore    grow@more.org    2223334445

    Write Single Row-copado           2              ${dataLine1}
    Write Single Row-copado           3              ${dataLine2}

    Save Excel Document-copado        ${output_path}/excelToDownload.xlsx

    Close All Excel Documents-copado

