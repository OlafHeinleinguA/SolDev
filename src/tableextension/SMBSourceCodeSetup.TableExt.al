tableextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(123456700; "SMB Seminar"; Code[10])
        {
            Caption = 'Seminar';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
    }
}
