page 123456702 "SMB Seminar Setup"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Seminar Setup';
    PageType = Card;
    SourceTable = "SMB Seminar Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Copy Comments To Posted Reg."; Rec."Copy Comments To Posted Reg.")
                {
                    ToolTip = 'Specifies the value of the Copy Comments To Posted Reg. field.';
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                field("Seminar Nos."; Rec."Seminar Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Nos. field.';
                    ApplicationArea = All;
                }
                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                {
                    ToolTip = 'Specifies the value of the Seminar Registration Nos. field.';
                    ApplicationArea = All;
                }
                field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.")
                {
                    ToolTip = 'Specifies the value of the Posted Seminar Reg. Nos. field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
