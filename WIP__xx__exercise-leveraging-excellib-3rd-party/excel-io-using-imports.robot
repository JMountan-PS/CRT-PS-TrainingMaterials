*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/excelLoad.resource
Resource    ../resources/excelWrite.resource

*** Variables ***
${excel-path}        ${CURDIR}/../testdata/BulkLeadData.xlsx

*** Test Cases ***
Open Existing excel and write to it
    Open Existing Excel Document-copado    ${excel-path}    LeadsData
    
    