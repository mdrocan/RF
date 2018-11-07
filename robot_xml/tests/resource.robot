*** Settings ***
Library    XML
Library    OperatingSystem

Documentation   Test suite should always import only one resource file.

*** Variables ***
${filename}    example_resp.xml
${location}      /tmp/tests/
${file} =    Parse XML    ${location}${filename}

*** Keywords ***
Verify Test
    ${linter} =    Run    rflint ${location}
    Log    ${linter}

Getfile
    Run    apk add wget
    ${put} =    Run    wget http://web/${filename}
    Log    ${put}
    File Should Exist    ${location}${filename}

Findfile
    ${output} =    Run    find / -name ${filename}
    Log    ${output}

Validate XML
    ${file} =    Parse XML    ${location}${filename}
    Should Be Equal    ${file.tag}    example
    ${first} =    Get Element    ${file}    first
    Should Be Equal    ${first.text}    jotain

    @{texts} =    Get Elements Texts    ${location}${filename}    third/child
    Length Should Be    ${texts}    2
    Should Be Equal    @{texts}[0]    more text
    Should Be Equal    @{texts}[1]    ${EMPTY}

    @{texts} =    Get Elements Texts   ${location}${filename}    toinen/homma
    Length Should Be    ${texts}    3

    ${_text} =    Get Elements    ${file}    fourth/aakkonen
    Length Should Be    ${_text}    2