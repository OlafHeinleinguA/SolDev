pageextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        addlast(content)
        {
            group("SMB SeminarGroup")
            {
                Caption = 'Seminar';
                
                field("SMB Seminar"; Rec."SMB Seminar")
                {
                    ToolTip = 'Specifies the value of the Seminar field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    
   
}