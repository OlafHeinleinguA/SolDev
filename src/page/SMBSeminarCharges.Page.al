page 123456724 "SMB Seminar Charges"
{
    Caption = 'Seminar Charges';
    PageType = List;
    SourceTable = "SMB Seminar Charge";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit of Measure Code"; Rec."Unit of Measure Code") { ApplicationArea = All; }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { ApplicationArea = All; }
                field("Currency Code"; Rec."Currency Code") { ApplicationArea = All; }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group") { ApplicationArea = All; }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group") { ApplicationArea = All; }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)") { ApplicationArea = All; }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)") { ApplicationArea = All; }
                field("To Invoice"; Rec."To Invoice") { ApplicationArea = All; }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}