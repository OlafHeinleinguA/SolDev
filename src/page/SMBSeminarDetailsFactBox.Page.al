page 123456717 "SMB Seminar Details FactBox"
{

    Caption = 'Seminar Details';
    PageType = CardPart;
    SourceTable = "SMB Seminar";

    layout
    {
        area(content)
        {

            field("No."; Rec."No.")
            {
                Caption = 'Seminar No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. field';
                trigger OnDrillDown()
                begin
                    Page.Run(Page::"SMB Seminar Card",Rec);
                end;
            }
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field';
            }
            field("Duration Days"; Rec."Duration Days")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Duration (Days) field';
            }
            field("Language Code"; Rec."Language Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Language Code field';
            }
            field("Minimum Participants"; Rec."Minimum Participants")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Minimum Participants field';
            }
            field("Maximum Participants"; Rec."Maximum Participants")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Maximum Participants field';
            }
            field("Seminar Price"; Rec."Seminar Price")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Seminar Price field';
            }
           

        }
    }

}
