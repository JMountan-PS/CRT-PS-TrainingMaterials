*** Settings ***
Library    ../libraries/GitOperations.py
Resource   ../resources/excelWrite.resource
Resource    ../resources/excelLoad.resource
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

Update Values in Existing Excel
      # First load and output excel data that currently exists
    @{all_leads}=    Load Lead Test Data From Excel

    #Open Excel for Writing 
    Open Existing Excel Document-copado    ${excel-path}    LeadsData
    
    # Get the first lead from the list (index 0)
    &{first_lead}=    Get From List    ${all_leads}    0
    
    # Access individual fields using dictionary syntax: ${dict}[key]
    Log To Console    \nFirst Lead Details:
    Log To Console    Name: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]

    #Use write single cell to update first row from Sarah Johnson -> Jim Smith
    Write Single Cell-copado               2                4    Jim
    Write Single Cell-copado               2                2    Smith
    
    Save Excel Document-copado             ${excel-path}

    #Load and output excel data that currently exists
    @{all_leads}=    Load Lead Test Data From Excel
    
    # Get the first lead from the list (index 0)
    &{first_lead}=    Get From List    ${all_leads}    0
    
    # Access individual fields using dictionary syntax: ${dict}[key]
    Log To Console    \nFirst Lead Details:
    Log To Console    Name: ${first_lead}[first_name] ${first_lead}[last_name]
    Log To Console    Company: ${first_lead}[company]
    Log To Console    Status: ${first_lead}[lead_status]
    