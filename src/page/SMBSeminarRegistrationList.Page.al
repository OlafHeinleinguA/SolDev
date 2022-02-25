page 123456713 "SMB Seminar Registration List"
{

    ApplicationArea = All;
    Caption = 'Seminar Registrations';
    PageType = List;
    SourceTable = "SMB Seminar Reg. Header";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SMB Seminar Registration";
    PromotedActionCategories = 'New,Process,Report,Seminar Registration,Posting';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field';
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar No. field';
                }
                field("Seminar Description"; Rec."Seminar Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Description field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duration (Days) field';
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
            }
        }
        area(factboxes)
        {
            part(SeminarDetails; "SMB Seminar Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }
       actions
    {
        area(navigation)
        {
            group("Seminar Registration")
            {
                Caption = 'Seminar Registration';
                Image = "Order";

                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "SMB Seminar Comment Sheet";
                    RunPageLink = "Document Type" = const("Seminar Registration"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
                area(Processing)
        {
             group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Finalize the document';

                    AboutTitle = 'Posting the registration';
                    // AboutText = 'Posting will ship or invoice the quantities on the order, or both. Post and Send can save the order as a file, print it, or attach it to an email, all in one go.';

                    // RunObject = codeunit "SMB Seminar-Post (Yes/No)";
                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"SMB Seminar-Post (Yes/No)",Rec);
                    end;
                }
            }
        }
    }

}