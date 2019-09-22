-- Necessary grant any dictionary to run this script
SELECT
    W.INST_ID RAC,
    P.SPID, W.SID,
    S.USERNAME,
    S.OSUSER,
    substr(W.EVENT,1,30) "Event",
    W.SECONDS_IN_WAIT sec,
    SQL.SQL_TEXT ,
    substr(module,1,20) "Module"
--,'XPLAN PLAN     ' || 'SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(''' || S.SQL_ID  || ''',format => ''ALL''));'
FROM
    GV$SESSION_WAIT W,
    GV$SESSION S,
    GV$PROCESS P,
    GV$SQLTEXT SQL
WHERE S.SID != (select sid from v$mystat where rownum=1)
    AND W.SID = S.SID
    AND W.INST_ID = S.INST_ID
    AND S.PADDR = P.ADDR
    AND S.INST_ID = P.INST_ID
    AND SQL.ADDRESS = S.SQL_ADDRESS
    AND SQL.INST_ID = S.INST_ID
    AND SQL.HASH_VALUE = S.SQL_HASH_VALUE
    AND W.WAIT_CLASS != 'Idle'
ORDER BY 
    W.SECONDS_IN_WAIT, W.SID, SQL.PIECE;