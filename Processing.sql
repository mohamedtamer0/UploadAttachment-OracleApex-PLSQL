/* Formatted on 29/07/2023 2:02:37 PM (QP5 v5.326) */
DECLARE
    l_attached_document_id   NUMBER;
    l_document_id            NUMBER;
    l_media_id               NUMBER;
    l_filename               VARCHAR2 (240);
    l_seq_num                NUMBER;
    l_blob_data              BLOB;
    l_file_id                NUMBER;
    blob_length              INTEGER;
    l_blob                   BLOB;
    l_mime_type              VARCHAR2 (2000);
    v_status                 VARCHAR2 (3);
    v_errormsg               VARCHAR2 (2000);
    V_FILE_EXISTS            INTEGER := 0;
BEGIN
    --GET Data from Temp Tables uploaded by oracle apex
    SELECT blob_content, mime_type
      INTO l_blob, l_mime_type
      FROM apex_application_temp_files
     WHERE NAME = :P5_XXX;

    --GET Current sequnce to be inserting
    SELECT QA_ATTACHMENT_seq.NEXTVAL INTO l_file_id FROM DUAL;

    --Prepare Zip File in Custom Interface
    INSERT INTO swdview.ATTACHMENT (file_id,
                                    Document_id,
                                    FILE_NAME,
                                    Document_Type,
                                    MIME_TYPE,
                                    raw_document,
                                    State,
                                    Uploading_date)
         VALUES (l_file_id,
                 :P5_XX,
                 SUBSTR ( :P5_XXX, INSTR ( :P5_XXX, '/', 1) + 1),
                 :P5_XXXX,
                 l_mime_type,
                 l_blob,
                 'Working',
                 SYSTIMESTAMP);

    COMMIT;
EXCEPTION
    WHEN OTHERS
    THEN
        v_status := 'ERR';
        v_errormsg := SQLERRM;
        COMMIT;
END;
