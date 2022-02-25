codeunit 123456701 "SMB Seminar-Post (Yes/No)"
{
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin

        if not Rec.Find() then
            Error(NothingToPostErr);

        SMBSeminarRegHeader.Copy(Rec);
        Code(SMBSeminarRegHeader);
        Rec := SMBSeminarRegHeader;
    end;

    Var
        NothingToPostErr: Label 'There is nothing to post.';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '%1 = Document Type';
    local procedure Code(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    
    begin
        if not confirm(PostConfirmQst,false,SMBSeminarRegHeader.TableCaption)then
            exit;
        Codeunit.Run(Codeunit::"SMB Seminar-Post",SMBSeminarRegHeader);
    end;
}