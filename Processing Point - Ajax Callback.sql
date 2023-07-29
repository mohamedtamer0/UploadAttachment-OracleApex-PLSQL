/* Formatted on 29/07/2023 1:57:04 PM (QP5 v5.326) */
DECLARE
    v_mimetype    VARCHAR2 (3000);
    b_blob        BLOB;
    n_len         NUMBER;
    v_FILE_NAME   VARCHAR2 (3000);
BEGIN
    SELECT RAW_DOCUMENT, FILE_NAME, MIME_TYPE
      INTO b_blob, v_FILE_NAME, v_mimetype
      FROM ATTACHMENT
     WHERE DOCUMENT_ID = 1;

    n_len := DBMS_LOB.getlength (b_blob);
    HTP.flush;
    HTP.init;
    -- you can change the mimetype according to the file type
    OWA_UTIL.mime_header (v_mimetype, FALSE);
    HTP.p ('Content-length: ' || n_len);
    --htp.p('Content-Disposition: inline; filename="' || v_FILE_NAME || '"');
    --htp.p('Set-Cookie: filedownload=true; path=/');
    OWA_UTIL.http_header_close;
    WPG_DOCLOAD.DOWNLOAD_FILE (b_blob);
END;
