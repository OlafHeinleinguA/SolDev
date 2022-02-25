table 123456702 "SMB Seminar Room"
{
    DataClassification = CustomerContent;
    Caption = 'Seminar Room';
    DataCaptionFields = Code, Name;
    LookupPageId = "SMB Seminar Room List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");

            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;
        }


        field(8; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            trigger OnValidate()
            var
                Char: DotNet Char;
                i: Integer;
            begin
                for i := 1 to StrLen("Phone No.") do
                    if Char.IsLetter("Phone No."[i]) then
                        FieldError("Phone No.", PhoneNoCannotContainLettersErr);
            end;

        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
            trigger OnValidate()
            var
                Char: DotNet Char;
                i: Integer;
            begin
                for i := 1 to StrLen("Telex No.") do
                    if Char.IsLetter("Telex No."[i]) then
                        FieldError("Telex No.", PhoneNoCannotContainLettersErr);
            end;
        }
        field(11; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(12; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
            trigger OnValidate()
            var
                Char: DotNet Char;
                i: Integer;
            begin
                for i := 1 to StrLen("Fax No.") do
                    if Char.IsLetter("Fax No."[i]) then
                        FieldError("Fax No.", PhoneNoCannotContainLettersErr);
            end;
        }
        field(13; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode(City, "Post Code", County, "Country/Region Code");
            end;
        }
        field(15; County; Text[30])
        {
            Caption = 'County';
        }
        field(16; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            trigger OnValidate()
            begin
                ValidateEmail();
            end;
        }
        field(17; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(26; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

        }
        field(39; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(40; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Machine));

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "Resource No." = '' then
                    exit;

                Resource.Get("Resource No.");
                Resource.TestField(Blocked, false);

                if Name = '' then
                    Name := Resource.Name;
            end;
        }
        field(41; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(42; "Max. Participants"; Integer)
        {
            Caption = 'Max. Participants';
            MinValue = 0;
        }
        field(43; "Responsible Contact No."; Code[20])
        {
            Caption = 'Responsible Contact No.';
            TableRelation = Contact;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            // end;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Name, "Internal/External") { }
    }



    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

    var
        PostCode: Record "Post Code";
        PhoneNoCannotContainLettersErr: Label 'must not contain letters';

    local procedure ValidateEmail()
    var
        MailManagement: Codeunit "Mail Management";
    begin
        if "E-Mail" = '' then
            exit;
        MailManagement.CheckValidEmailAddresses("E-Mail");
    end;
}