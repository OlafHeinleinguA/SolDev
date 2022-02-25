page 123456735 "SMB Pst. Sem. Reg. Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "SMB Posted Seminar Reg. Line";
    Editable = false;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                }
                field(Participated; Participated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participated field';
                }
                field("Registration Date"; "Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field';
                }
                field("Confirmation Date"; "Confirmation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmation Date field';
                }
                field("To Invoice"; "To Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Invoice field';
                }
                field(Registered; Registered)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registered field';
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field';
                }
                field("Seminar Price (LCY)"; "Seminar Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Price (LCY) field';
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount % field';
                }
                field("Line Discount Amount (LCY)"; "Line Discount Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount Amount (LCY) field';
                }
                field("Line Amount (LCY)"; "Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field';
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount field';
                }
            }
        }
    }
}

