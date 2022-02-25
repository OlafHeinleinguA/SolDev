table 123456703 "SMB Instructor"
{
    DataClassification = CustomerContent;
    Caption = 'Instructor';
    DataCaptionFields = Code, Name;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = True;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(10; "E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                ValidateEmail();
            end;
        }
        field(11; "Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
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

        field(30; "Contact No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact No.';
            TableRelation = Contact;
            trigger OnValidate()
            var
                Contact: Record Contact;
            begin
                Contact.Get("Contact No.");
                if Name = '' then
                    Name := Contact.Name;

                if "E-Mail" = '' then
                    "E-Mail" := Contact."E-Mail";

                if "Phone No." = '' then
                    "Phone No." := Contact."Phone No.";

                if "Salesperson Code" = '' then
                    "Salesperson Code" := Contact."Salesperson Code";

                if "Language Code" = '' then
                    "Language Code" := Contact."Language Code";
            end;
        }
        field(31; "Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person));
            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                Resource.Get("Resource No.");
                Resource.TestField(Blocked, false);
                if Name = '' then
                    Name := Resource.Name;
            end;

        }
        field(32; "Internal/External"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Intern/Extern';
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(34; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(35; "Language Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            // end;
        }

    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Name, "Contact No.", "Resource No.", "Internal/External") { }
    }
    var
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