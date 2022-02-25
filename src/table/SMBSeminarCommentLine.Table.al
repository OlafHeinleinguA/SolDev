table 123456704 "SMB Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DrillDownPageID = "SMB Seminar Comment List";
    LookupPageID = "SMB Seminar Comment List";

    fields
    {
        field(1; "Document Type"; Enum "SMB Seminar Comm. Line Doc. Type")
        {
            Caption = 'Document Type';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        SemCommentLine: Record "SMB Seminar Comment Line";
    begin
        SemCommentLine.SetRange("Document Type", "Document Type");
        SemCommentLine.SetRange("No.", "No.");
        SemCommentLine.SetRange("Document Line No.", "Document Line No.");
        SemCommentLine.SetRange(Date, WorkDate());
        if not SemCommentLine.FindFirst() then
            Date := WorkDate();


    end;

    procedure CopyComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SemCommentLine: Record "SMB Seminar Comment Line";
        SemCommentLine2: Record "SMB Seminar Comment Line";

    begin

        SemCommentLine.SetRange("Document Type", FromDocumentType);
        SemCommentLine.SetRange("No.", FromNumber);
        if SemCommentLine.FindSet() then
            repeat
                SemCommentLine2 := SemCommentLine;
                SemCommentLine2."Document Type" := "SMB Seminar Comm. Line Doc. Type".FromInteger(ToDocumentType);
                SemCommentLine2."No." := ToNumber;
                SemCommentLine2.Insert();
            until SemCommentLine.Next() = 0;
    end;

    procedure CopyLineComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLineNo: Integer)
    var
        SemCommentLineSource: Record "SMB Seminar Comment Line";
        SemCommentLineTarget: Record "SMB Seminar Comment Line";

    begin

        SemCommentLineSource.SetRange("Document Type", FromDocumentType);
        SemCommentLineSource.SetRange("No.", FromNumber);
        SemCommentLineSource.SetRange("Document Line No.", FromDocumentLineNo);
        if SemCommentLineSource.FindSet() then
            repeat
                SemCommentLineTarget := SemCommentLineSource;
                SemCommentLineTarget."Document Type" := "SMB Seminar Comm. Line Doc. Type".FromInteger(ToDocumentType);
                SemCommentLineTarget."No." := ToNumber;
                SemCommentLineTarget."Document Line No." := ToDocumentLineNo;
                SemCommentLineTarget.Insert();
            until SemCommentLineSource.Next() = 0;
    end;

    procedure CopyLineCommentsFromSalesLines(FromDocumentType: Integer;
                                            ToDocumentType: Integer; FromNumber: Code[20];
                                            ToNumber: Code[20];
                                            var TempSemRegLineSource: Record "SMB Seminar Reg. Line" temporary)
    var
        SemCommentLineSource: Record "SMB Seminar Comment Line";
        SemCommentLineTarget: Record "SMB Seminar Comment Line";

        NextLineNo: Integer;
    begin


        SemCommentLineTarget.SetRange("Document Type", ToDocumentType);
        SemCommentLineTarget.SetRange("No.", ToNumber);
        SemCommentLineTarget.SetRange("Document Line No.", 0);
        if SemCommentLineTarget.FindLast() then;
        NextLineNo := SemCommentLineTarget."Line No." + 10000;
        SemCommentLineTarget.Reset();

        SemCommentLineSource.SetRange("Document Type", FromDocumentType);
        SemCommentLineSource.SetRange("No.", FromNumber);
        if TempSemRegLineSource.FindSet() then
            repeat
                SemCommentLineSource.SetRange("Document Line No.", TempSemRegLineSource."Line No.");
                if SemCommentLineSource.FindSet() then
                    repeat
                        SemCommentLineTarget := SemCommentLineSource;
                        SemCommentLineTarget."Document Type" := "SMB Seminar Comm. Line Doc. Type".FromInteger(ToDocumentType);
                        SemCommentLineTarget."No." := ToNumber;
                        SemCommentLineTarget."Document Line No." := 0;
                        SemCommentLineTarget."Line No." := NextLineNo;
                        SemCommentLineTarget.Insert();
                        NextLineNo += 10000;
                    until SemCommentLineSource.Next() = 0;
            until TempSemRegLineSource.Next() = 0;
    end;

    procedure CopyHeaderComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SemCommentLineSource: Record "Sales Comment Line";
        SemCommentLineTarget: Record "Sales Comment Line";

    begin


        SemCommentLineSource.SetRange("Document Type", FromDocumentType);
        SemCommentLineSource.SetRange("No.", FromNumber);
        SemCommentLineSource.SetRange("Document Line No.", 0);
        if SemCommentLineSource.FindSet() then
            repeat
                SemCommentLineTarget := SemCommentLineSource;
                SemCommentLineTarget."Document Type" := "Sales Comment Document Type".FromInteger(ToDocumentType);
                SemCommentLineTarget."No." := ToNumber;
                SemCommentLineTarget.Insert();
            until SemCommentLineSource.Next() = 0;
    end;

    procedure DeleteComments(DocType: Option; DocNo: Code[20])
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        if not IsEmpty then
            DeleteAll();
    end;

    procedure ShowComments(DocType: Option; DocNo: Code[20]; DocLineNo: Integer)
    var
        SemCommentSheet: Page "SMB Seminar Comment Sheet";
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        SetRange("Document Line No.", DocLineNo);
        Clear(SemCommentSheet);
        SemCommentSheet.SetTableView(Rec);
        SemCommentSheet.RunModal();
    end;


}

