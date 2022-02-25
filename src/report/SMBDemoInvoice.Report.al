report 123456799 "SMB Demo Invoice"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(Number = filter('1..5'));
            trigger OnAfterGetRecord()
            begin
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader."No." := '';
                SalesHeader.Insert(true);
                SalesHeader.Validate("Sell-to Customer No.", '10000');
                SalesHeader.Modify(true);

                NextLineNo := 10000;

                for i := 1 to 3 do begin
                    SalesLine.Init();
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Line No." := NextLineNo;
                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.",'70000');
                    SalesLine.Validate(Quantity,Random(5));
                    SalesLine.Insert(true);
                    NextLineNo += 10000;
                end;

            end;

        }
    }



    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        NextLineNo: Integer;
        i: Integer;
}