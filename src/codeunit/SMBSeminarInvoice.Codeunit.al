codeunit 123456710 "SMB Seminar Invoice"
{
    Permissions = TableData "SMB Seminar Ledger Entry" = imd;
    
var
SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterTestSalesLine', '', false, false)]
    local procedure CheckSemLedgEntryOnAfterTestSalesLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean);
    begin
        if (SalesLine."Document Type" = SalesLine."Document Type"::Invoice) and 
            (SalesLine."SMB Apply-to Seminar Entry" <> 0)
        then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry.TestField("Closed by Document No.",'');
        end;
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)"; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean);
    begin
         if (SalesLine."Document Type" = SalesLine."Document Type"::Invoice) and 
            (SalesLine."SMB Apply-to Seminar Entry" <> 0)
        then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry."Closed by Document No." := SalesInvLine."Document No.";
            SMBSeminarLedgerEntry.Modify();
        end;
    end;
    
}