page 123456721 "SMB Seminar Ledger Entries"
{
    Caption = 'Seminar Ledger Entries';
    PageType = List;
    UsageCategory = History;
    ApplicationArea = All;
    SourceTable = "SMB Seminar Ledger Entry";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field';
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Document Date field';
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry Type field';
                }
                field("Seminar No."; "Seminar No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar No. field';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                }
                field("Charge Type"; "Charge Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Charge Type field';
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field';
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field';
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field';
                }
                field("Total Price"; "Total Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Price field';
                }
                field(Chargeable; Chargeable)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Chargeable field';
                }
                field("Participant Contact No."; "Participant Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participant Contact No. field';
                }
                field("Participant Name"; "Participant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participant Name field';
                }
                field("Instructor Code"; "Instructor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instructor Code field';
                }
                field("Seminar Room Code"; "Seminar Room Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Room Code field';
                }
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field';
                }
                field("Seminar Registration No."; "Seminar Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Registration No. field';
                }
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = All;}
            systempart(Notes; Notes) { ApplicationArea = All;}
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Executes the &Navigate action';

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.Run();
                end;
            }
        }
    }
}