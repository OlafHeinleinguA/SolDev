page 123456705 "SMB Seminar Room Card"
{
    Caption = 'Seminar Room Card';
    SourceTable = "SMB Seminar Room";
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Code field';


                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Name field';

                }
                field("Name 2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Name 2 field.';

                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';

                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Address 2 field.';

                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Post Code field.';

                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the City field';

                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';

                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Contact field.';

                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Code field.';

                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Blocked field.';

                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Phone No. field.';

                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Phone No. field.';

                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Fax No. field.';

                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the E-Mail field.';

                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Home Page field.';

                }
                field("Responsible Contact No."; Rec."Responsible Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Responsible Contact No. field.';

                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Resource No. field.';

                }
            }
            group(Planing)
            {
                Caption = 'Planing';
                field("Internal/External"; Rec."Internal/External")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the value of the Internal/External field';

                }
                field("Max. Participants"; Rec."Max. Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max. Participants field.';

                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }
}