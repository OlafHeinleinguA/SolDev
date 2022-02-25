page 123456701 "SMB Seminar List"
{

    ApplicationArea = All;
    Caption = 'Seminars';
    PageType = List;
    SourceTable = "SMB Seminar";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SMB Seminar Card";
    PromotedActionCategories = 'New,Process,Report,Seminar';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ToolTip = 'Specifies the value of the Duration (Days) field.';
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the value of the Language Code field.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ToolTip = 'Specifies the value of the Minimum Participants field.';
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field.';
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field.';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Seminar")
            {
                Caption = '&Seminar';

                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Seminar),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "SMB Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = FIELD("No.");
                    RunPageView = SORTING("Seminar No.")
                                  ORDER(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(Creation)
        {
            group(NewDocument)
            {
                Caption = 'New Document';
                action(NewSeminarRegistration)
                {
                    ApplicationArea = All;
                    Caption = 'New Seminar Registration';
                    Image = NewDocument;
                    RunObject = page "SMB Seminar Registration";
                    RunPageLink = "Seminar No." = field("No.");
                    RunPageMode = Create;
                    ToolTip = 'Executes the New Seminar Registration action.';
                }
            }
        }
    }
}
