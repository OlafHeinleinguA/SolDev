codeunit 123456731 "SMB Sem. Jnl.-Check Line"
{
    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';
        Text002: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        TimeSheetMgt: Codeunit "Time Sheet Management";

    procedure RunCheck(var SMBSeminarJnlLine: Record "SMB Seminar Journal Line")
    
    begin

        GLSetup.Get();
        with SMBSeminarJnlLine do begin
            if EmptyLine() then
                exit;

            TestField("Seminar No.");
            TestField("Posting Date");  

            case "Charge Type" of
                "Charge Type"::Instructor:
                    TestField("Instructor Code");
                "Charge Type"::Room:
                    TestField("Seminar Room Code");
                "Charge Type"::Participant:
                    TestField("Participant Contact No.");
                "Charge Type"::Charge:
                TestField("Source No.");
            end;

            if Chargeable then
                TestField("Bill-to Customer No.");      

            CheckPostingDate(SMBSeminarJnlLine);

            if "Document Date" <> 0D then
                if "Document Date" <> NormalDate("Document Date") then
                    FieldError("Document Date", Text000);

            

            // CheckDimensions(ResJnlLine);
        end;

      
    end;

    local procedure CheckPostingDate(SMBSeminarJnlLine: Record "SMB Seminar Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin    
        with SMBSeminarJnlLine do begin
            if "Posting Date" <> NormalDate("Posting Date") then
                FieldError("Posting Date", Text000);          

            UserSetupManagement.CheckAllowedPostingDate("Posting Date");
        end;
    end;

    local procedure CheckDimensions(ResJnlLine: Record "Res. Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeCheckDimensions(ResJnlLine, IsHandled);
        if IsHandled then
            exit;

        with ResJnlLine do begin
            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                Error(
                  Text002,
                  TableCaption, "Journal Template Name", "Journal Batch Name", "Line No.",
                  DimMgt.GetDimCombErr);

            TableID[1] := DATABASE::Resource;
            No[1] := "Resource No.";
            TableID[2] := DATABASE::"Resource Group";
            No[2] := "Resource Group No.";
            TableID[3] := DATABASE::Job;
            No[3] := "Job No.";
            if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                if "Line No." <> 0 then
                    Error(
                      Text003,
                      TableCaption, "Journal Template Name", "Journal Batch Name", "Line No.",
                      DimMgt.GetDimValuePostingErr)
                else
                    Error(DimMgt.GetDimValuePostingErr);
        end;
    end;

   
}





