codeunit 123456704 "SMB Seminar Navigate"
{
    SingleInstance = true;

    var
        SMBPostedSeminarRegHeader: Record "SMB Posted Seminar Reg. Header";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', false, false)]
    local procedure InsertDocEntryOnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; Sender: Page Navigate)

    begin
        if SMBPostedSeminarRegHeader.ReadPermission() then begin
            SMBPostedSeminarRegHeader.Reset();
            SMBPostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
            SMBPostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
            Sender.InsertIntoDocEntry(
                DocumentEntry,
                DATABASE::"SMB Posted Seminar Reg. Header",
                SMBPostedSeminarRegHeader.TableCaption,
                SMBPostedSeminarRegHeader.Count);
        end;

        if SMBSeminarLedgerEntry.ReadPermission() then begin
            SMBSeminarLedgerEntry.Reset();
            SMBSeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
            SMBSeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
            SMBSeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
            Sender.InsertIntoDocEntry(
                DocumentEntry,
                DATABASE::"SMB Seminar Ledger Entry",
                SMBSeminarLedgerEntry.TableCaption,
                SMBSeminarLedgerEntry.Count);
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', false, false)]
    local procedure ShowOnAfterNavigateShowRecords(var Sender: Page Navigate; TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; var TempDocumentEntry: Record "Document Entry"; SalesInvoiceHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; PurchInvHeader: Record "Purch. Inv. Header"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250]);
    begin
        case TableID of
            DATABASE::"SMB Posted Seminar Reg. Header":
                begin
                    SMBPostedSeminarRegHeader.Reset();
                    SMBPostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
                    SMBPostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
                    if TempDocumentEntry."No. of Records" = 1 then
                        PAGE.Run(PAGE::"SMB Pst. Sem. Registration", SMBPostedSeminarRegHeader)
                    else
                        PAGE.Run(0, SMBPostedSeminarRegHeader);
                end;
            DATABASE::"SMB Seminar Ledger Entry":
                begin
                    SMBSeminarLedgerEntry.Reset();
                    SMBSeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
                    SMBSeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
                    SMBSeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
                    PAGE.Run(0, SMBSeminarLedgerEntry);
                end;
        end;
    end;
}