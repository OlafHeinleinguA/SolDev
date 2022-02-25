table 123456721 "SMB Posted Seminar Charge"
{
    Caption = 'Posted Seminar Charge';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SMB Posted Seminar Reg. Header";
            NotBlank = true;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = Item,Resource,"G/L Account";
            OptionCaption = 'Item,Resource,G/L Account';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const (Item)) Item
            else
            if (Type = const ("Resource")) Resource
            else
            if (Type = const ("G/L Account")) "G/L Account";
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(7; "Unit Price (LCY)"; Decimal)
        {
            Caption = 'Unit Price';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(8; "Line Amount (LCY)"; Decimal)
        {
            Caption = 'Total Price';
            AutoFormatType = 1;
            Editable = false;
        }
        field(9; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(11; "Unit of Measure Code"; Code[10])
        {
            TableRelation = if (Type = const (Item)) "Item Unit of Measure" where ("Item No." = field ("No."))
            else
            if (Type = const (Resource)) "Resource Unit of Measure".Code where ("Resource No." = field ("No."))
            else
            "Unit of Measure";
        }
        field(12; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(13; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(14; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
        }
        field(15; Registered; Boolean)
        {
            Caption = 'Registered';
            Editable = false;
        }
        field(16; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(17; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(21; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(22; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}