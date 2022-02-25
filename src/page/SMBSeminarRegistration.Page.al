page 123456710 "SMB Seminar Registration"
{

    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = "SMB Seminar Reg. Header";
    PromotedActionCategories = 'New,Process,Report,Seminar Registration,Posting';

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
                    trigger OnAssistEdit()
                    begin
                        if rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;

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
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duration (Days) field';
                }
                field("Instructor Code"; Rec."Instructor Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instructor Code field';
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Instructor Name field';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Date field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
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
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Language Code field';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Salesperson Code field';
                }
                field("No. of Participants"; Rec."No. of Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Participants field';
                }
            }
            part(Lines; "SMB Seminar Reg. Subpage")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
            group(SeminarRoom)
            {
                Caption = 'Seminar Room';
                field("Room Code"; Rec."Room Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Room Code field';
                }
                field("Room Name"; Rec."Room Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field';
                }
                field("Room Name 2"; Rec."Room Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name 2 field';
                }
                field("Room Address"; Rec."Room Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field';
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address 2 field';
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Post Code field';
                }
                field("Room City"; Rec."Room City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field';
                }
                field("Room Country/Region Code"; Rec."Room Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field';
                }
                field("Room County"; Rec."Room County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the County field';
                }

                field("Room Contact"; Rec."Room Contact")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contact field';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Price field';
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

        }
        area(factboxes)
        {
            part(SeminarDetails; "SMB Seminar Details FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Seminar No.");
            }
            part(ContactDetails; "SMB Cont. Details Factbox")
            {
                ApplicationArea = All;
                Provider = Lines;
                SubPageLink = "No." = field("Participant Contact No.");
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

