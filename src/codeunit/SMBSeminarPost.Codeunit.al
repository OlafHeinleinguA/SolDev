codeunit 123456700 "SMB Seminar-Post"
{
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        TempSMBSeminarRegLine: Record "SMB Seminar Reg. Line" temporary;
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        LineCount: Integer;
    begin
        ClearAll();
        TempSMBSeminarRegLine.DeleteAll();
        SMBSeminarRegHeader := Rec;
        LineCount := 0;

        // Header
        CheckAndUpdateHeader(SMBSeminarRegHeader);

        // Lines
        SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
        SMBSeminarRegLine.SetRange(Registered, false);

        if SMBSeminarRegLine.FindSet() then
            repeat
                LineCount += 1;
                Window.Update(2, LineCount);
                PostSemRegLine(SMBSeminarRegHeader, SMBSeminarRegLine);

                TempSMBSeminarRegLine := SMBSeminarRegLine;
                TempSMBSeminarRegLine.Registered := true;
                TempSMBSeminarRegLine.Insert();

            until SMBSeminarRegLine.Next() = 0;

        if TempSMBSeminarRegLine.Find('-') then
            repeat
                SMBSeminarRegLine.Get(TempSMBSeminarRegLine."Document No.", TempSMBSeminarRegLine."Line No.");
                SMBSeminarRegLine := TempSMBSeminarRegLine;
                SMBSeminarRegLine.Modify();
            until TempSMBSeminarRegLine.Next() = 0;

        //Gebühren 
        //......

        // Aufräumen

        SMBSeminarRegHeader."Last Posting No." := SMBSeminarRegHeader."Posting No.";
        SMBSeminarRegHeader."Posting No." := '';
        SMBSeminarRegHeader.Modify();


        SMBSeminarRegLine.Setrange(Registered);
        SMBSeminarRegLine.DeleteAll();
        SMBSeminarCommentLine.DeleteComments(
            SMBSeminarCommentLine."Document Type"::"Seminar Registration",
            SMBSeminarRegHeader."No.");
        if SMBSeminarRegHeader.HasLinks then
            SMBSeminarRegHeader.DeleteLinks();
        SMBSeminarRegHeader.Delete();

        Window.Close();
        Rec := SMBSeminarRegHeader;
        Commit();
    end;

    var
        SourceCodeSetup: Record "Source Code Setup";
        SMBPostedSeminarRegHeader: record "SMB Posted Seminar Reg. Header";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        SeminarJnlPostLine: Codeunit "SMB Sem. Jnl.-Post Line";
        SrcCode: Code[10];
        LastResEntryNo: Integer;
        Window: Dialog;
        NothingToPostErr: Label 'There is nothing to post.';
        PostingLines2Msg: Label 'Posting lines              #2######', Comment = 'Counter';

    local procedure CheckAndUpdateHeader(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        UserSetupManagement: Codeunit "User Setup Management";
        ModifyHeader: Boolean;
    begin
        with SMBSeminarRegHeader do begin
            CheckMandatoryHeaderFields(SMBSeminarRegHeader);
            UserSetupManagement.CheckAllowedPostingDate("Posting Date");

            //gibt buchbare Zeilen
            SMBSeminarRegLine.Reset();
            SMBSeminarRegLine.SetRange("Document No.", "No.");
            SMBSeminarRegLine.SetRange(Registered, false);
            if SMBSeminarRegLine.IsEmpty then
                Error(NothingToPostErr);

            InitProgressWindow(SMBSeminarRegHeader);

            ModifyHeader := UpdatePostingNos(SMBSeminarRegHeader);

            if ModifyHeader then begin
                Modify();
                Commit();
            end;

            LockTables(SMBSeminarRegHeader);

            SourceCodeSetup.Get();
            SrcCode := SourceCodeSetup."SMB Seminar";

            InsertPostedHeaders(SMBSeminarRegHeader);

            //Ressourcen- und Seminarposten für Trainer erstellen (=2 Funktionsaufrufe!)
            PostResJnlLine(0, SMBSeminarRegHeader);
            PostSeminarJnlLine(0, SMBSeminarRegHeader, SMBSeminarRegLine);
            //Ressourcen- und Seminarposten für Raum erstellen (=2 Funktionsaufrufe!)
            PostResJnlLine(1, SMBSeminarRegHeader);
            PostSeminarJnlLine(1, SMBSeminarRegHeader, SMBSeminarRegLine);


        end;
    end;

    local procedure CheckMandatoryHeaderFields(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        with SMBSeminarRegHeader do begin
            TestField("Seminar No.");
            TestField("Posting Date");
            TestField("Document Date");
            TestField(Status, Status::Closed);
            TestField("Instructor Code");
            TestField("Room Code");
        end;

    end;

    procedure InitProgressWindow(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin

        Window.Open(
          '#1#################################\\' +
          PostingLines2Msg);

        Window.Update(1, StrSubstNo('%1 %2', SMBSeminarRegHeader.TableCaption, SMBSeminarRegHeader."No."));
    end;

    local procedure UpdatePostingNos(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header") ModifyHeader: Boolean
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        UpdatePostingNo(SMBSeminarRegHeader, NoSeriesMgt, ModifyHeader);

    end;

    local procedure UpdatePostingNo(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var NoSeriesMgt: Codeunit NoSeriesManagement; var ModifyHeader: Boolean)
    begin

        with SMBSeminarRegHeader do
            if ("Posting No." = '') then begin

                TestField("Posting No. Series");

                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                ModifyHeader := true;
            end;
    end;

    local procedure LockTables(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    // SMBSeminarCharge: Record "SMB Seminar Charge";
    begin
        SMBSeminarRegLine.LockTable();
        // SMBSeminarCharge.LockTable();
        SMBSeminarRegHeader.LockTable();
        SMBSeminarRegHeader.Find('=');
    end;

    local procedure InsertPostedHeaders(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        PostingStatusTxt: Label 'Registration %1  -> Posted Reg. %2', Comment = '%1 %2 %3';
    begin


        with SMBSeminarRegHeader do begin
            InsertSemRegHeader(SMBSeminarRegHeader, SMBPostedSeminarRegHeader);
            Window.Update(2, StrSubstNo(PostingStatusTxt, "No.", SMBPostedSeminarRegHeader."No."));
        end;
    end;

    local procedure InsertSemRegHeader(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var SMBPostedSeminarRegHeader: Record "SMB Posted Seminar Reg. Header")
    var

        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminarSetup: Record "SMB Seminar Setup";
        RecordLinkManagement: Codeunit "Record Link Management";

    begin
        with SMBSeminarRegHeader do begin
            SMBPostedSeminarRegHeader.Init();
            SMBPostedSeminarRegHeader.TransferFields(SMBSeminarRegHeader);

            SMBPostedSeminarRegHeader."No." := "Posting No.";
            SMBPostedSeminarRegHeader."No. Series" := "Posting No. Series";
            SMBPostedSeminarRegHeader."Registration No." := "No.";
            SMBPostedSeminarRegHeader."Registration No. Series" := "No. Series";

            SMBPostedSeminarRegHeader."Source Code" := SrcCode;
            SMBPostedSeminarRegHeader."User ID" := UserId;
            SMBPostedSeminarRegHeader."No. Printed" := 0;
            SMBPostedSeminarRegHeader.Insert();

            SMBSeminarSetup.Get();
            if SMBSeminarSetup."Copy Comments To Posted Reg." then begin
                SMBSeminarCommentLine.CopyComments(
                    SMBSeminarCommentLine."Document Type"::"Seminar Registration",
                    SMBSeminarCommentLine."Document Type"::"Posted Seminar Registration",
                    "No.",
                    SMBPostedSeminarRegHeader."No.");
                RecordLinkManagement.CopyLinks(SMBSeminarRegHeader, SMBPostedSeminarRegHeader);
            end;
        end;
    end;

    local procedure PostResJnlLine(ChargeType: Option Instructor,Room,Charge; SMBSeminarRegHeader: record "SMB Seminar Reg. Header"): Integer
    var
        ResJnlLine: Record "Res. Journal Line";
        SMBInstructor: Record "SMB Instructor";
        InstRes: Record Resource;
        SMBSeminarRoom: Record "SMB Seminar Room";
        RoomRes: Record Resource;
        ResLedgEntry: Record "Res. Ledger Entry";
    begin
        with SMBSeminarRegHeader do begin
            ResJnlLine.Init();
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Document No." := SMBPostedSeminarRegHeader."No.";
            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine.Description := "Seminar Description";
            //  ResJnlLine."Work Type Code"
            //  ResJnlLine."Job No."
            //  ResJnlLine."Direct Unit Cost"
            //  ResJnlLine."Total Cost"
            //  ResJnlLine."Unit Price"
            //  ResJnlLine."Total Price"
            ResJnlLine."Source Code" := SrcCode;
            ResJnlLine."Reason Code" := "Reason Code";

            //  ResJnlLine."Gen. Bus. Posting Group"
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Document Date" := "Document Date";
            //  ResJnlLine."External Document No."
            ResJnlLine."Posting No. Series" := "Posting No. Series";

            //  ResJnlLine."Dimension Set ID"

            case ChargeType of
                ChargeType::Instructor:
                    begin
                        if SMBInstructor.Code <> "Instructor Code" then
                            SMBInstructor.Get("Instructor Code");
                        if InstRes."No." <> SMBInstructor."Resource No." then
                            InstRes.Get(SMBInstructor."Resource No.");
                        ResJnlLine."Resource No." := SMBInstructor."Resource No.";
                        ResJnlLine."Unit of Measure Code" := InstRes."Base Unit of Measure";
                        ResJnlLine.Quantity := "Duration Days";
                        ResJnlLine."Qty. per Unit of Measure" := 1;
                        ResJnlLine."Unit Cost" := InstRes."Unit Cost";
                    end;
                ChargeType::Room:
                    begin
                        if SMBSeminarRoom.Code <> "Room Code" then
                            SMBSeminarRoom.Get("Room Code");
                        if RoomRes."No." <> SMBSeminarRoom."Resource No." then
                            RoomRes.Get(SMBSeminarRoom."Resource No.");
                        ResJnlLine."Resource No." := SMBSeminarRoom."Resource No.";
                        ResJnlLine."Unit of Measure Code" := RoomRes."Base Unit of Measure";
                        ResJnlLine.Quantity := "Duration Days";
                        ResJnlLine."Qty. per Unit of Measure" := 1;
                        ResJnlLine."Unit Cost" := RoomRes."Unit Cost";
                    end;
                ChargeType::Charge:
                    begin
                        //     ResJnlLine."Resource No." := SeminarCharge."No.";
                        //     ResJnlLine."Unit of Measure Code" := ChargeRes."Base Unit of Measure";
                        //     ResJnlLine.Quantity := SeminarCharge.Quantity;
                        //     ResJnlLine."Qty. per Unit of Measure" := SeminarCharge."Qty. per Unit of Measure";
                        //     ResJnlLine."Unit Cost" := ChargeRes."Unit Cost";
                    end;
            end;

            ResJnlPostLine.RunWithCheck(ResJnlLine);
            ResLedgEntry.FindLast();
            LastResEntryNo := ResLedgEntry."Entry No.";
        end;
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant,Charge;
                                        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
                                        SMBSeminarRegLine: Record "SMB Seminar Reg. Line")
    var
        SMBSeminarJournalLine: Record "SMB Seminar Journal Line";
        SMBInstructor: Record "SMB Instructor";
        InstRes: Record Resource;
        SMBSeminarRoom: Record "SMB Seminar Room";
        RoomRes: Record Resource;
    begin
        with SMBSeminarRegHeader do begin
            SMBSeminarJournalLine.Init();
            SMBSeminarJournalLine."Seminar No." := "Seminar No.";
            SMBSeminarJournalLine."Posting Date" := "Posting Date";
            SMBSeminarJournalLine."Document Date" := "Document Date";
            SMBSeminarJournalLine."Entry Type" := SMBSeminarJournalLine."Entry Type"::Registration;
            SMBSeminarJournalLine."Document No." := SMBPostedSeminarRegHeader."No.";
            SMBSeminarJournalLine."Starting Date" := "Starting Date";
            SMBSeminarJournalLine."Seminar Registration No." := "No.";
            SMBSeminarJournalLine."Res. Ledger Entry No." := LastResEntryNo;
            LastResEntryNo := 0;
            SMBSeminarJournalLine."Source Type" := SMBSeminarJournalLine."Source Type"::Seminar;
            SMBSeminarJournalLine."Source No." := "Seminar No.";
            SMBSeminarJournalLine."Source Code" := SrcCode;
            SMBSeminarJournalLine."Reason Code" := "Reason Code";
            SMBSeminarJournalLine."Posting No. Series" := "Posting No. Series";
            case ChargeType of
                ChargeType::Instructor:
                    begin
                        SMBSeminarJournalLine."Charge Type" := ChargeType;
                        SMBSeminarJournalLine.Chargeable := false;
                        SMBInstructor.Get("Instructor Code");
                        SMBSeminarJournalLine."Instructor Code" := "Instructor Code";
                        SMBSeminarJournalLine.Description := SMBInstructor.Name;
                        SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                        SMBSeminarJournalLine.Quantity := "Duration Days";
                    end;
                ChargeType::Room:
                    begin
                        SMBSeminarJournalLine."Charge Type" := ChargeType;
                        SMBSeminarJournalLine.Chargeable := false;
                        SMBSeminarRoom.Get("Room Code");
                        SMBSeminarJournalLine."Seminar Room Code" := "Room Code";
                        SMBSeminarJournalLine.Description := SMBSeminarRoom.Name;
                        SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                        SMBSeminarJournalLine.Quantity := "Duration Days";
                    end;
                ChargeType::Participant:
                    begin
                        SMBSeminarJournalLine."Charge Type" := ChargeType;
                        SMBSeminarJournalLine.Description := SMBSeminarRegLine."Participant Name";
                        SMBSeminarJournalLine."Participant Contact No." := SMBSeminarRegLine."Participant Contact No.";
                        SMBSeminarRegLine.CalcFields("Participant Name");
                        SMBSeminarJournalLine."Participant Name" := SMBSeminarRegLine."Participant Name";
                        SMBSeminarJournalLine."Bill-to Customer No." := SMBSeminarRegLine."Bill-to Customer No.";
                        SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                        SMBSeminarJournalLine.Quantity := 1;
                        SMBSeminarJournalLine."Unit Price" := SMBSeminarRegLine."Line Amount (LCY)";
                        SMBSeminarJournalLine."Total Price" := SMBSeminarRegLine."Line Amount (LCY)";
                        SMBSeminarJournalLine.Chargeable := SMBSeminarRegLine."To Invoice";
                        SMBSeminarJournalLine."Instructor Code" := SMBSeminarRegHeader."Instructor Code";
                    end;
            // ChargeType::Charge:
            //     begin
            //         SMBSeminarJournalLine."Charge Type" := ChargeType;
            //         SMBSeminarJournalLine.Description := SeminarCharge.Description;
            //         SMBSeminarJournalLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
            //         SMBSeminarJournalLine.Type := SeminarCharge.Type;
            //         SMBSeminarJournalLine.Quantity := SeminarCharge.Quantity;
            //         SMBSeminarJournalLine."Unit Price" := SeminarCharge."Unit Price (LCY)";
            //         SMBSeminarJournalLine."Total Price" := SeminarCharge."Line Amount (LCY)";
            //         SMBSeminarJournalLine.Chargeable := SeminarCharge."To Invoice";
            //     end;
            end;
            SeminarJnlPostLine.RunWithCheck(SMBSeminarJournalLine);
        end;
    end;

    local procedure PostSemRegLine(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var SMBSeminarRegLine: Record "SMB Seminar Reg. Line")
    begin
        TestAndUpdateSemRegLine(SMBSeminarRegLine);

        PostSeminarJnlLine(2, SMBSeminarRegHeader, SMBSeminarRegLine);
        InsertPstSemRegLine(SMBSeminarRegLine);
    end;

    local procedure TestAndUpdateSemRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line")
    begin
        with SMBSeminarRegLine do begin
            TestField("Bill-to Customer No.");
            TestField("Participant Contact No.");
            TestField("Gen. Bus. Posting Group");
            TestField("VAT Bus. Posting Group");

            if not "To Invoice" then begin
                "Seminar Price (LCY)" := 0.0;
                "Line Discount %" := 0.0;
                "Line Discount Amount (LCY)" := 0.0;
                "Line Amount (LCY)" := 0.0;
                "Line Amount" := 0.0;
            end;
        end;
    end;

    local procedure InsertPstSemRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line")
    var
        SMBPostedSeminarRegLine: Record "SMB Posted Seminar Reg. Line";
    begin
        SMBPostedSeminarRegLine.Init();
        SMBPostedSeminarRegLine.TransferFields(SMBSeminarRegLine);
        SMBPostedSeminarRegLine."Document No." := SMBPostedSeminarRegHeader."No.";
        SMBPostedSeminarRegLine.Registered := true;
        SMBPostedSeminarRegline.Participated := true;
        SMBPostedSeminarRegLine.Insert();
    end;

}