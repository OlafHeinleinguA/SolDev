page 123456736 "SMB Posted Seminar Reg. List"
{
    Caption = 'Pst. Seminar Registration List';
    PageType = List;
    SourceTable = "SMB Posted Seminar Reg. Header";
    CardPageID = "SMB Pst. Sem. Registration";
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field';
                }
                field("Seminar No."; "Seminar No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar No. field';
                }
                field("Seminar Description"; "Seminar Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Description field';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
                field("Duration Days"; "Duration Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duration (Days) field';
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Participants field';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = All;}
            systempart(Notes; Notes)  { ApplicationArea = All;}
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "SMB Seminar Comment Sheet";
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Document Type" = const("Posted Seminar Registration"));
                    ToolTip = 'Executes the Co&mments action';
                }
                action("&Charges")
                {
                    ApplicationArea = All;
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page "SMB Posted Seminar Charges";
                    RunPageLink = "Document No." = field("No.");
                    ToolTip = 'Executes the &Charges action';
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                ApplicationArea = All;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action';

                trigger OnAction()
                begin
                    Navigate();
                end;
            }
        }
    }
}