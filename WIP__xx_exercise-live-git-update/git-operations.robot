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
${excel_path}    ${CURDIR}/../testdata/BulkLeadData.xlsx

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

    #Open Excel for Writing 
    Open Existing Excel Document-copado    ${excel_path}    LeadsData

    #Line 1 is currently
    #Open,Johnson,Acme Corporation,Sarah,Ms.,555-0101,VP of Sales,sarah.johnson@acme.com,www.acme.com,Website

    #Use write single cell to update first row from Sarah Johnson -> Jim Smith
    Write Single Cell-copado               2                4    Jim
    Write Single Cell-copado               2                2    Smith
    Write Single Cell-copado               2                3    Growmore

    #Line 2 is currently
    #Working,Chen,TechStart Inc,Michael,Mr.,555-0102,Chief Technology Officer,michael.chen@techstart.com,www.techstart.com,External Referral

    ${DataLine2}                        Create List         Open    Mountan    Gov Company    Jared    Dr.
    Write Single Row-copado             3                   ${DataLine2}

    Save Excel Document-copado          ${output_path}/BulkLeadData.xlsx

