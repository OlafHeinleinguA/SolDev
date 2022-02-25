page 123456706 "SMB Seminar Reg. Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "SMB Seminar Reg. Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field.';
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                    ToolTip = 'Specifies the value of the Participant Contact No. field.';
                    ApplicationArea = All;
                }
                field("Participant Name"; Rec."Participant Name")
                {
                    ToolTip = 'Specifies the value of the Participant Name field.';
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ToolTip = 'Specifies the value of the Registration Date field.';
                    ApplicationArea = All;
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ToolTip = 'Specifies the value of the Confirmation Date field.';
                    ApplicationArea = All;
                }
                field(Participated; Rec.Participated)
                {
                    ToolTip = 'Specifies the value of the Participated field.';
                    ApplicationArea = All;
                }
                field(Registered; Rec.Registered)
                {
                    ToolTip = 'Specifies the value of the Registered field.';
                    ApplicationArea = All;
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ToolTip = 'Specifies the value of the To Invoice field.';
                    ApplicationArea = All;
                }
                field("Seminar Price (LCY)"; Rec."Seminar Price (LCY)")
                {
                    ToolTip = 'Specifies the value of the Seminar Price (LCY) field.';
                    ApplicationArea = All;
                 
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ToolTip = 'Specifies the value of the Line Discount % field.';
                    ApplicationArea = All;
                }
                
                field("Line Discount Amount (LCY)"; Rec."Line Discount Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Line Discount Amount (LCY) field.';
                    ApplicationArea = All;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ToolTip = 'Specifies the value of the Amount (LCY) field.';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {

            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Related Information")
                {
                    Caption = 'Related Information';
                    Image = RelatedInformation;
                    action("Co&mments")
                    {
                        ApplicationArea = Comments;
                        Caption = 'Co&mments';
                        Image = ViewComments;
                        ToolTip = 'View or add comments for the record.';

                        trigger OnAction()
                        begin
                            Rec.ShowLineComments();
                        end;
                    }

                }
            }
        }

    }
    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update();
    end;
}