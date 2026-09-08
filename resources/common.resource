*** Settings ***
Library                         QWeb
Library                         QForce
Library                         QVision
Library                         String
Library                         Collections
Library                         DateTime


*** Keywords ***
Setup Browser
    Set Library Search Order    QForce                        QWeb                        QVision
    Open Browser                about:blank                 Chrome
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              30s                         #sometimes salesforce is slow


Login
    [Documentation]             Login to Salesforce instance via JwtAuthenticate
    ...                         See JwtAuthenticate documentation for step-by-step Setup Instructions
    ...                         https://docs.copado.com/resources/Storage/copado-robotic-testing-publication/CRT%20Site/qwords-reference/current/qwords/_attachments/QForce.html?tag\=Authentication#Jwt%20Authenticate
    Set Library Search Order    QForce                        QWeb                        QVision
    JwtAuthenticate             ${client_id}                  ${SF_username}              ${private_key}    #custom_url=${SF_URL}
    JwtLogin

Home
    [Documentation]             Navigate to homepage using a quick keyword
    Set Library Search Order    QForce    QWeb    QVision
    JwtLogin                    /lightning/page/home   
