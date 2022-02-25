codeunit 123456732 "SMB Sem. Jnl.-Post Line"
{
    Permissions = TableData "SMB Seminar Ledger Entry" = imd,
                  TableData "SMB Seminar Register" = imd;

    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SMBSeminarJnlLine: Record "SMB Seminar Journal Line";

        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";

        SMBSemReg: Record "SMB Seminar Register";
        SMBInstructor: Record "SMB Instructor";
        SMBSeminarRoom: Record "SMB Seminar Room";
        Customer: Record Customer;
        SMBSemJnlCheckLine: Codeunit "SMB Sem. Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;

    procedure RunWithCheck(var SMBSeminarJnlLine2: Record "SMB Seminar Journal Line")
    begin
        SMBSeminarJnlLine.Copy(SMBSeminarJnlLine2);
        Code();
        SMBSeminarJnlLine2 := SMBSeminarJnlLine;
    end;

    local procedure "Code"()

    begin
        with SMBSeminarJnlLine do begin
            if EmptyLine() then
                exit;

            SMBSemJnlCheckLine.RunCheck(SMBSeminarJnlLine);

            case "Charge Type" of
                "Charge Type"::Instructor:
                    begin
                        SMBInstructor.get("Instructor Code");
                        SMBInstructor.TestField("Resource No.");
                        SMBInstructor.TestField(Blocked, false);
                    end;
                "Charge Type"::Room:
                    begin
                        SMBSeminarRoom.get("Seminar Room Code");
                        SMBSeminarRoom.TestField("Resource No.");
                        SMBSeminarRoom.TestField(Blocked, false);
                    end;
                "Charge Type"::Participant:
                    begin
                        Customer.Get("Bill-to Customer No.");
                        Customer.TestField(Blocked,Customer.Blocked::" ");
                    end;
            end;

            if NextEntryNo = 0 then begin
                SMBSeminarLedgerEntry.LockTable();
                NextEntryNo := SMBSeminarLedgerEntry.GetLastEntryNo() + 1;
            end;

            if "Document Date" = 0D then
                "Document Date" := "Posting Date";

            if SMBSemReg."No." = 0 then begin
                SMBSemReg.LockTable();
                if (not SMBSemReg.FindLast()) or (SMBSemReg."To Entry No." <> 0) then begin
                    SMBSemReg.Init();
                    SMBSemReg."No." := SMBSemReg."No." + 1;
                    SMBSemReg."From Entry No." := NextEntryNo;
                    SMBSemReg."To Entry No." := NextEntryNo;
                    SMBSemReg."Creation Date" := Today;
                    // SMBSemReg."Creation Time" := Time;
                    SMBSemReg."Source Code" := "Source Code";
                    SMBSemReg."Journal Batch Name" := "Journal Batch Name";
                    SMBSemReg."User ID" := UserId;
                    SMBSemReg.Insert();
                end;
            end;
            SMBSemReg."To Entry No." := NextEntryNo;
            SMBSemReg.Modify();





            SMBSeminarLedgerEntry.Init();
            SMBSeminarLedgerEntry.CopyFromSemJnlLine(SMBSeminarJnlLine);

            SMBSeminarLedgerEntry."User ID" := UserId;
            SMBSeminarLedgerEntry."Entry No." := NextEntryNo;


            SMBSeminarLedgerEntry.Insert(true);

            NextEntryNo := NextEntryNo + 1;
        end;


    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();
        GLSetupRead := true;
    end;



}

