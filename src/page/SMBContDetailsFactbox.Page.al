page 123456718 "SMB Cont. Details Factbox"
{
    PageType = CardPart;
    Caption = 'Contact Details';
    SourceTable = Contact;
    
    layout
    {
        area(Content)
        {
            
            field("No."; Rec."No.")
            {
                Caption = 'Contact No.';
                ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                ApplicationArea = All;
                trigger OnDrillDown()
                begin
                    Page.Run(page::"Contact Card",Rec);
                end;
            }
            field(Name; Rec.Name)
            {
                ToolTip = 'Specifies the name.';
                ApplicationArea = All;
            }
            field("Company Name"; Rec."Company Name")
            {
                ToolTip = 'Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.';
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                ToolTip = 'Specifies the contact''s address.';
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ToolTip = 'Specifies the city where the contact is located.';
                ApplicationArea = All;
            }
            field("Post Code"; Rec."Post Code")
            {
                ToolTip = 'Specifies the postal code.';
                ApplicationArea = All;
            }
            field("Phone No."; Rec."Phone No.")
            {
                ToolTip = 'Specifies the contact''s phone number.';
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ToolTip = 'Specifies the email address of the contact.';
                ApplicationArea = All;
            }
            field(Image; Rec.Image)
            {
                ToolTip = 'Specifies the picture of the contact, for example, a photograph if the contact is a person, or a logo if the contact is a company.';
                ApplicationArea = All;
            }
        }
    }
    
  
    
    
    
}