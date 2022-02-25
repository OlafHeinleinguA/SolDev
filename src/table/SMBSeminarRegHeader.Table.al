table 123456710 "SMB Seminar Reg. Header"
{
    Caption = 'Seminar Registration';
    DataCaptionFields = "No.", "Starting Date", "Seminar Description";
    LookupPageID = "SMB Seminar Registration List";
    DrillDownPageID = "SMB Seminar Registration List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SMBSeminarSetup.Get();
                    NoSeriesMgt.TestManual(SMBSeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;

        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            trigger OnValidate()
            begin
                TestStatusOpen();
                TestNoLineExist();
                if ("Starting Date" < WorkDate()) and ("Starting Date" <> 0D) then
                    Message(
                        DateIsInThePastMsg,
                        FieldCaption("Starting Date"));
            end;

        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SMB Seminar";
            trigger OnValidate()
            begin
                if "Seminar No." <> xRec."Seminar No." then begin
                    TestStatusOpen();
                    TestNoLineExist();

                    SMBSeminar.Get("Seminar No.");
                    SMBSeminar.TestBlocked();

                    "Seminar Description" := SMBSeminar.Description;
                    "Duration Days" := SMBSeminar."Duration Days";
                    "Minimum Participants" := SMBSeminar."Minimum Participants";
                    "Maximum Participants" := SMBSeminar."Maximum Participants";
                    "Language Code" := SMBSeminar."Language Code";
                    Validate("Seminar Price", SMBSeminar."Seminar Price");
                    "Gen. Prod. Posting Group" := SMBSeminar."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := SMBSeminar."VAT Prod. Posting Group";
                end;

            end;

        }
        field(4; "Seminar Description"; Text[100])
        {
            Caption = 'Seminar Description';

        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "SMB Instructor";
            trigger OnValidate()
            begin
                CalcFields("Instructor Name");
            end;

        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("SMB Instructor".Name where(Code = field("Instructor Code")));
        }

        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning,Registration,Closed,Canceled;

        }
        field(9; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
            trigger OnValidate()
            begin
                TestStatusOpen();
                TestNoLineExist();

            end;

        }
        field(10; "Minimum Participants"; Integer)
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
        field(11; "Maximum Participants"; Integer)
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
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            trigger OnValidate()
            begin
                TestStatusOpen();
                TestNoLineExist();
            end;
        }
        field(13; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
            trigger OnValidate()
            begin
                // wenn sich der Seminarpreis tatsächlich ändert
                // und es gibt änderbare Zeilen, soll gefragt werden (Confirm)
                // ob die Zeilen geändert werden sollen, wenn ja, dann alle Zeilen einzeln lesen
                // und den Seminarpreis validieren
                // wenn nein, soll nur der preis im Kopf stehen

                //     if "Seminar Price" <> xRec."Seminar Price" then begin
                //         SMBSeminarRegLine.Reset();
                //         SMBSeminarRegLine.SetRange("Document No.", "No.");
                //         SMBSeminarRegLine.SetRange(Registered, false);
                //         if not SMBSeminarRegLine.IsEmpty then
                //             if Confirm('willst Du die Zeilen ändern', true) then begin
                //                 SMBSeminarRegLine.FindSet(true);
                //                 repeat
                //                     SMBSeminarRegLine.Validate("Seminar Price (LCY)", "Seminar Price");
                //                     SMBSeminarRegLine.Modify();
                //                 until SMBSeminarRegLine.Next() = 0;
                //             end;
                //     end;

                if "Seminar Price" <> xRec."Seminar Price" then
                    UpdateSemRegLinesByFieldNo(FieldNo("Seminar Price"), true, true);

            end;

        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen();
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(16; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            trigger OnValidate()
            begin
                TestStatusOpen();

            end;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";


        }
        field(20; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
            TableRelation = "SMB Seminar Room";
            trigger OnValidate()
            begin
                if "Room Code" <> '' then begin
                    SMBSeminarRoom.Get("Room Code");
                    SMBSeminarRoom.TestField(Blocked, false);

                end else
                    SMBSeminarRoom.Init();

                "Room Name" := SMBSeminarRoom.Name;
                "Room Name 2" := SMBSeminarRoom."Name 2";
                "Room Address" := SMBSeminarRoom.Address;
                "Room Address 2" := SMBSeminarRoom."Address 2";
                "Room City" := SMBSeminarRoom.City;
                "Room Contact" := SMBSeminarRoom.Contact;
                "Room Country/Region Code" := SMBSeminarRoom."Country/Region Code";
                "Room Post Code" := SMBSeminarRoom."Post Code";
                "Room County" := SMBSeminarRoom.City;
            end;
        }
        field(21; "Room Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(22; "Room Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(23; "Room Address"; Text[100])
        {
            Caption = 'Address';
        }
        field(24; "Room Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(25; "Room City"; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code".City
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Room City", "Room Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(26; "Room Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Room City", "Room Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(29; "Room County"; Text[30])
        {
            Caption = 'County';
        }
        field(42; Comment; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("SMB Seminar Comment Line" where("Document Type" = const("Seminar Registration"),
                                                                "No." = field("No."),
                                                                "Document Line No." = const(0)));
        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        trigger OnValidate()
        begin
            TestField("Posting Date");
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FieldCaption("Posting No."), FieldCaption("Posting No. Series"));
        end;

        }
        field(53; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(54; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(56; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(61; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(62; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            trigger OnLookup()
            begin
                SMBSeminarRegHeader := Rec;
                SMBSeminarSetup.Get();
                SMBSeminarSetup.TestField("Posted Seminar Reg. Nos.");

                if NoSeriesMgt.LookupSeries(SMBSeminarSetup."Posted Seminar Reg. Nos.", SMBSeminarRegHeader."Posting No. Series") then begin
                    SMBSeminarRegHeader.Validate("Posting No. Series");
                    Rec := SMBSeminarRegHeader;
                end;
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    SMBSeminarSetup.Get();
                    SMBSeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SMBSeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        field(63; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(100; "No. of Participants"; Integer)
        {
            Caption = 'No. of Participants';
            FieldClass = FlowField;
            Editable = False;
            CalcFormula = count("SMB Seminar Reg. Line" where("Document No." = field("No.")));

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
        fieldgroup(DropDown; "No.", "Starting Date", "Seminar No.", "Seminar Description", "Room Code") { }
    }

    trigger OnDelete()
    begin
        TestStatusClosed();
        TestLineRegistered();

        SMBSeminarRegLine.SetRange("Document No.", "No.");
        SMBSeminarRegLine.DeleteAll();

        SMBSeminarCommentLine.SetRange("Document Type", SMBSeminarCommentLine."Document Type"::"Seminar Registration");
        SMBSeminarCommentLine.SetRange("No.", "No.");
        SMBSeminarCommentLine.DeleteAll();

    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SMBSeminarSetup.Get();
            SMBSeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SMBSeminarSetup."Seminar Registration Nos.", xRec."No. Series", "Posting Date", "No.", "No. Series");
        end;

        InitRecord();

        if GetFilter("Seminar No.") <> '' then
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
                Validate("Seminar No.", GetRangeMin("Seminar No."));
    end;

    trigger OnRename()
    begin
        Error(CannotRenameErr, TableCaption);
    end;


    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        SMBSeminarSetup: Record "SMB Seminar Setup";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminar: Record "SMB Seminar";
        SMBSeminarRoom: Record "SMB Seminar Room";
        PostCode: Record "Post Code";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenProdPostingGrp: Record "Gen. Product Posting Group";

        CannotRenameErr: Label 'You cannot rename a %1.', Comment = '%1 = Tablecaption';
        CannotDeleteErr: Label '%1 cannot be deleted because there are booked and unbooked %2', Comment = '%1 %2';
        LineExistErr: Label 'There ist one or more %1 for the %2 %3=%4', Comment = '%1 %2 %3 %4';
        DateIsInThePastMsg: Label 'Please note, that the %1 is in the past', Comment = '%1';
        MustBeLEErr: Label 'must be less or equal %1', Comment = '%1 = Fieldcaption Max Amount';
        MustBeGEErr: Label 'must be greater or equal %1', Comment = '%1 Fieldname';
        Text045: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';


    procedure AssistEdit(OldSemReg: Record "SMB Seminar Reg. Header"): Boolean
    begin
        SMBSeminarRegHeader := Rec;
        SMBSeminarSetup.Get();
        SMBSeminarSetup.TestField("Seminar Registration Nos.");
        if NoSeriesMgt.SelectSeries(SMBSeminarSetup."Seminar Registration Nos.", OldSemReg."No. Series", SMBSeminarRegHeader."No. Series") then begin
            SMBSeminarSetup.Get();
            SMBSeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.SetSeries(SMBSeminarRegHeader."No.");
            Rec := SMBSeminarRegHeader;
            exit(true);
        end;
    end;

    local procedure InitRecord()
    begin
        SMBSeminarSetup.Get();
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SMBSeminarSetup."Posted Seminar Reg. Nos.");

        if
          ("Posting Date" = 0D)
       then
            "Posting Date" := WorkDate();

        "Document Date" := WorkDate();

        "Posting Description" := Format(Tablecaption) + ' ' + "No.";
    end;

    procedure TestStatusOpen()
    begin
        if not (Status in [Status::Planning, Status::Registration]) then
            FieldError(Status);
    end;

    procedure TestStatusClosed()
    begin
        if not (Status in [Status::Canceled, Status::Closed]) then
            FieldError(Status);
    end;

    local procedure TestLineRegistered()
    begin
        SMBSeminarRegLine.Reset();
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        SMBSeminarRegLine.SetRange(Registered, true);
        if not SMBSeminarRegLine.IsEmpty then begin
            SMBSeminarRegLine.SetRange(Registered, false);
            if not SMBSeminarRegLine.IsEmpty then
                Error(
                    CannotDeleteErr,
                    TableCaption,
                    SMBSeminarRegLine.TableCaption);
        end;
    end;

    local procedure TestNoLineExist()
    begin
        SMBSeminarRegLine.Reset();
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        if not SMBSeminarRegLine.IsEmpty then
            Error(
                LineExistErr,
                SMBSeminarRegLine.TableCaption,
                TableCaption,
                FieldCaption("No."),
                "No.");
    end;

    procedure UpdateSemRegLinesByFieldNo(ChangedFieldNo: Integer; AskQuestion: Boolean; UnregisteredLinesOnly: Boolean)
    var
        "Field": Record "Field";
        Question: Text[250];

        ConfirmUpdateLinesQst: Label 'You have modified %1.\\Do you want to update the lines?', Comment = 'You have modified Shipment Date.\\Do you want to update the lines?';

    begin

        SMBSeminarRegLine.Reset();
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        if UnregisteredLinesOnly then
            SMBSeminarRegLine.SetRange(Registered, false);

        if SMBSeminarRegLine.IsEmpty then
            exit;

        if not Field.Get(DATABASE::"SMB Seminar Reg. Header", ChangedFieldNo) then
            Field.Get(DATABASE::"SMB Seminar Reg. Line", ChangedFieldNo);


        if AskQuestion then begin
            Question := StrSubstNo(ConfirmUpdateLinesQst, Field."Field Caption");
            if GuiAllowed then
                if not DIALOG.Confirm(Question, true) then
                    exit;
        end;

        SMBSeminarRegLine.LockTable();
        Modify();

        if SMBSeminarRegLine.FindSet() then
            repeat
                case ChangedFieldNo of
                    FieldNo("Seminar Price"):
                        SMBSeminarRegLine.Validate("Seminar Price (LCY)", "Seminar Price");
                end;

                SMBSeminarRegLine.Modify(true);
            until SMBSeminarRegLine.Next() = 0;
    end;

    local procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[20]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "No. Series";
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.Get(NoSeriesCode);
            if NoSeries."Date Order" then
                Error(
                  Text045,
                  FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  NoSeries.FieldCaption("Date Order"), NoSeries."Date Order", TableCaption,
                  NoCapt, No);
        end;
    end;


}