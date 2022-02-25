page 123456722 "SMB Seminar Registers"
{
    Caption = 'Seminar Registers';
    PageType = List;
    UsageCategory = History;
    ApplicationArea = All;
    SourceTable = "SMB Seminar Register";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field';
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field';
                }
                field("Source Code"; "Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field';
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field';
                }
                field("From Entry No."; "From Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Entry No. field';
                }
                field("To Entry No."; "To Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Entry No. field';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) {ApplicationArea = All; }
            systempart(Notes; Notes) {ApplicationArea = All; }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Register)
            {
                Caption = 'Register';
                action("Seminar Ledger")
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Ledger';
                    Image = Ledger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "SMB Seminar Reg.-Show Ledger";
                    ToolTip = 'Executes the Seminar Ledger action';

                }
            }
        }

    }
}