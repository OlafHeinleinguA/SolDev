table 123456711 "SMB Seminar Reg. Line"
{
    Caption = 'Seminar Registration Line';
    DataCaptionFields = "Document No.", "Participant Name";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SMB Seminar Reg. Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
            trigger OnValidate()
            begin
                TestStatusOpen();
                TestField("Participant Contact No.", '');
                GetSemRegHeader();
                SMBSeminarRegHeader.TestStatusOpen();
                SMBSeminarRegHeader.TestField("Seminar No.");
                Validate("Seminar Price (LCY)", SMBSeminarRegHeader."Seminar Price");
                "Registration Date" := WorkDate();

                Customer.get("Bill-to Customer No.");
                Customer.TestField(Blocked, Customer.Blocked::" ");
                "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
                Validate("Currency Code", Customer."Currency Code");
            end;

            // trigger OnLookup()
            // var
            //     SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
            // begin
            //     with SMBSeminarRegLine do begin
            //         SMBSeminarRegLine := Rec;
            //         Customer.FilterGroup(2);
            //         Customer.SetRange("Location Code", 'BLAU');
            //         Customer.FilterGroup(0);

            //         Customer."No." := "Bill-to Customer No.";
            //         if Customer.Find('=><') then;

            //         Customer.SetCurrentKey(Name);

            //         if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then begin
            //             Validate("Bill-to Customer No.", Customer."No.");
            //             Rec := SMBSeminarRegLine;
            //         end;
            //     end;
            // end;

        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
            trigger OnValidate()
            begin
                SMBSeminarRegLine.Reset();
                SMBSeminarRegLine.SetRange("Document No.", "Document No.");
                SMBSeminarRegLine.SetRange("Participant Contact No.", "Participant Contact No.");
                SMBSeminarRegLine.SetFilter("Line No.", '<>%1', "Line No.");
                if not SMBSeminarRegLine.IsEmpty then
                    FieldError("Participant Contact No.", ParticipantAlreadyExistErr);

                Contact.Get("Participant Contact No.");
                Contact.TestField("Company No.");
                ContactBusinessRelation.Reset();
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("Contact No.", Contact."Company No.");
                if not ContactBusinessRelation.FindFirst() then
                    FieldError("Participant Contact No.", 'hat keinen Debitor')
                else
                    if "Bill-to Customer No." <> ContactBusinessRelation."No." then
                        FieldError("Participant Contact No.", 'falscher Debitor');

                CalcFields("Participant Name");
            end;

            trigger OnLookup()
            begin
                TestStatusOpen();
                TestField("Bill-to Customer No.");

                with SMBSeminarRegLine do begin
                    SMBSeminarRegLine := Rec;
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                    ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                    if not ContactBusinessRelation.FindFirst() then
                        Error(NoContactRelatedErr);

                    Contact.Reset();
                    Contact.FilterGroup(2);
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                    Contact.FilterGroup(0);

                    Contact."No." := "Participant Contact No.";
                    if Contact.Find('=><') then;

                    if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then begin
                        Validate("Participant Contact No.", Contact."No.");
                        Rec := SMBSeminarRegLine;
                    end;
                end;
            end;

        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
        }
        field(10; "Seminar Price (LCY)"; Decimal)
        {
            Caption = 'Seminar Price (LCY)';
            AutoFormatType = 1;
            trigger OnValidate()
            begin
                TestStatusOpen();
                Validate("Line Discount %");
            end;

        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            trigger OnValidate()
            begin
                ValidateLineDiscountPercent();
            end;

        }
        field(12; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
            AutoFormatType = 1;

            trigger OnValidate()
            begin

                "Line Discount Amount (LCY)" := Round("Line Discount Amount (LCY)");

                TestStatusOpen();

                if xRec."Line Discount Amount (LCY)" <> "Line Discount Amount (LCY)" then
                    UpdateLineDiscPct();

                UpdateAmounts();

            end;

        }
        field(13; "Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            trigger OnValidate()
            var
                MaxLineAmount: Decimal;

            begin

                "Line Amount (LCY)" := Round("Line Amount (LCY)");
                MaxLineAmount := Round("Seminar Price (LCY)");

                if "Line Amount (LCY)" < 0 then
                    if "Line Amount (LCY)" < MaxLineAmount then
                        Error(LineAmountInvalidErr);

                if "Line Amount (LCY)" > 0 then
                    if "Line Amount (LCY)" > MaxLineAmount then
                        Error(LineAmountInvalidErr);

                Validate("Line Discount Amount (LCY)", MaxLineAmount - "Line Amount (LCY)");
            end;
        }

        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            //TODO Editable = false;
        }
        field(15; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then
                        Validate("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(16; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            trigger OnValidate()
            begin
                TestStatusOpen();
                UpdateCurrencyFactor();
                UpdateAmounts();
            end;


        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;


        }
        field(19; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            trigger OnValidate()
            begin
                TestStatusOpen();
                if "Currency Code" <> '' then begin
                    Currency.get("Currency Code");
                    "Line Amount" := Round("Line Amount", Currency."Amount Rounding Precision");
                    Validate(
                        "Line Amount (LCY)",
                        CurrExchRate.ExchangeAmtFCYToLCY(
                            GetDate(),
                            "Currency Code",
                            "Line Amount",
                            "Currency Factor"));

                end else begin
                    "Line Amount" := Round("Line Amount");
                    Validate("Line Amount (LCY)", "Line Amount");
                end;
            end;

        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        GetSemRegHeader();
        SMBSeminarRegHeader.TestStatusOpen();
        TestStatusOpen();

        SMBSeminarCommentLine.SetRange("Document Type", SMBSeminarCommentLine."Document Type"::"Seminar Registration");
        SMBSeminarCommentLine.SetRange("No.", "Document No.");
        SMBSeminarCommentLine.SetRange("Document Line No.", "Line No.");
        SMBSeminarCommentLine.DeleteAll();
    end;

    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        NoContactRelatedErr: Label 'There is no businessrelation contact.';
        ParticipantAlreadyExistErr: Label 'already exist';
        LineDiscountPctErr: Label 'The value in the Line Discount % field must be between 0 and 100.';
        LineAmountInvalidErr: Label 'You have set the line amount to a value that results in a discount that is not valid. Consider increasing the unit price instead.';

    local procedure TestStatusOpen()
    begin
        TestField(Registered, false);
    end;

    procedure ShowLineComments()
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminarCommentSheet: Page "SMB Seminar Comment Sheet";
    begin
        TestField("Document No.");
        TestField("Line No.");
        SMBSeminarCommentLine.SetRange("Document Type", SMBSeminarCommentLine."Document Type"::"Seminar Registration");
        SMBSeminarCommentLine.SetRange("No.", "Document No.");
        SMBSeminarCommentLine.SetRange("Document Line No.", "Line No.");
        SMBSeminarCommentSheet.SetTableView(SMBSeminarCommentLine);
        SMBSeminarCommentSheet.RunModal();
    end;

    local procedure GetSemRegHeader()
    begin
        if SMBSeminarRegHeader."No." <> "Document No." then
            SMBSeminarRegHeader.Get("Document No.");
    end;

    procedure ValidateLineDiscountPercent()
    begin

        TestStatusOpen();

        "Line Discount Amount (LCY)" :=
          Round(
            Round("Seminar Price (LCY)") *
            "Line Discount %" / 100);

        UpdateAmounts();
    end;

    procedure UpdateAmounts()
    var

        LineAmount: Decimal;

    begin

        LineAmount := Round("Seminar Price (LCY)") - "Line Discount Amount (LCY)";

        if "Line Amount (LCY)" <> LineAmount then
            "Line Amount (LCY)" := LineAmount;

        if "Currency Code" <> '' then
            "Line Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                    GetDate(),
                    "Currency Code",
                    "Line Amount (LCY)",
                    "Currency Factor")
        else
            "Line Amount" := "Line Amount (LCY)";

    end;

    local procedure UpdateLineDiscPct()
    var
        LineDiscountPct: Decimal;

        IsOutOfStandardDiscPctRange: Boolean;
    begin


        if Round("Seminar Price (LCY)") <> 0 then begin
            LineDiscountPct := Round(
                "Line Discount Amount (LCY)" / Round("Seminar Price (LCY)") * 100,
                0.00001);
            IsOutOfStandardDiscPctRange := not (LineDiscountPct in [0 .. 100]);

            if IsOutOfStandardDiscPctRange then
                Error(LineDiscountPctErr);
            "Line Discount %" := LineDiscountPct;
        end else
            "Line Discount %" := 0;
    end;

    procedure UpdateCurrencyFactor()
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        CurrencyDate: Date;
    begin

        if "Currency Code" <> '' then
            CurrencyDate := GetDate()
        else
            CurrencyDate := WorkDate();

        if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code")
        else
            "Currency Factor" := 0;
    end;

    procedure GetDate(): Date
    begin
        GetSemRegHeader();
        if SMBSeminarRegHeader."Posting Date" <> 0D then
            exit(SMBSeminarRegHeader."Posting Date");
        exit(WorkDate());
    end;
}

