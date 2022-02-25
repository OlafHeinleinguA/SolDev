table 123456700 "SMB Seminar"
{
    DataClassification = ToBeClassified;

    LookupPageId = "SMB Seminar List";
    DataCaptionFields = "No.", Description, "Duration Days";
    Caption = 'Seminar';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SMBSeminarSetup.Get();
                    NoSeriesMgt.TestManual(SMBSeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, MaxStrLen("Search Description"));
            end;
        }
        field(4; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(20; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }

        field(22; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(24; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(27; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Seminar),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            // end;

        }
        field(32; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(33; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(40; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
        }
        field(41; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
            trigger OnValidate()
            begin
                if ("Minimum Participants" > "Maximum Participants") and
                    ("Minimum Participants" > 0) and
                    ("Maximum Participants" > 0)
                then
                    FieldError(
                        "Minimum Participants",
                        StrSubstNo(
                            MustBeLEErr,
                            FieldCaption("Maximum Participants")));
            end;
        }
        field(42; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
            trigger OnValidate()
            begin
                if ("Maximum Participants" < "Minimum Participants") and
                    ("Minimum Participants" > 0) and
                    ("Maximum Participants" > 0)
                then
                    FieldError(
                        "Maximum Participants",
                        StrSubstNo(
                            MustBeGEErr,
                            FieldCaption("Minimum Participants")));
            end;
        }
        field(43; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(44; "Seminar Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Seminar Price';
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Language Code", "Duration Days") { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SMBSeminarSetup.Get();
            SMBSeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SMBSeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnDelete()
    begin
        SMBSeminarRegHeader.SetRange("Seminar No.", "No.");
        if not SMBSeminarRegHeader.IsEmpty then
            Error(
                SemRegExistErr,
                TableCaption,
                FieldCaption("No."),
                "No.",
                SMBSeminarRegHeader.TableCaption);

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll();

    end;

    trigger OnRename()
    begin
        CommentLine.RenameCommentLine(CommentLine."Table Name"::Seminar, xRec."No.", "No.");
        "Last Date Modified" := Today;
    end;

    var
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        SMBSeminarSetup: Record "SMB Seminar Setup";
        SMBSeminar: Record "SMB Seminar";
        CommentLine: Record "Comment Line";
        // SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MustBeLEErr: Label 'must be less or equal %1', Comment = '%1 = Fieldcaption Max Amount';
        MustBeGEErr: Label 'must be greater or equal %1', Comment = '%1 Fieldname';
        SemRegExistErr: Label 'You cannot delete the %1 %2=%3 because there is one or more %4.', Comment = '%1 %2 %3 %4';


    procedure AssistEdit(OldSem: Record "SMB Seminar"): Boolean
    begin
        SMBSeminar := Rec;
        SMBSeminarSetup.Get();
        SMBSeminarSetup.TestField("Seminar Nos.");
        if NoSeriesMgt.SelectSeries(SMBSeminarSetup."Seminar Nos.", OldSem."No. Series", SMBSeminar."No. Series") then begin
            SMBSeminarSetup.Get();
            SMBSeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.SetSeries(SMBSeminar."No.");
            Rec := SMBSeminar;
            exit(true);
        end;
    end;

    procedure TestBlocked()

    begin
        TestField(Blocked, false);
    end;
}