page 123456700 "SMB Seminar Card"
{

    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = "SMB Seminar";
    PromotedActionCategories = 'New,Process,Report,Seminar';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                    Importance = Promoted;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field';
                    Importance = Promoted;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description 2 field';
                    Importance = Additional;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Blocked field';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Description field';
                    Importance = Additional;
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duration (Days) field';
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Date Modified field';
                    Importance = Additional;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Language Code field';
                }

            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Price field';
                    Importance = Promoted;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field';
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field';
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
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
