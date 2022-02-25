report 123456700 "SMB Create Seminar Invoices"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Create Seminar Invoices';
    ProcessingOnly = true;

    dataset
    {
        dataitem(SMBSeminarLedgerEntry; "SMB Seminar Ledger Entry")
        {
            DataItemTableView = sorting("Bill-to Customer No.", Chargeable)
                                where("Charge Type" = const(Participant),
                                    Chargeable = const(true),
                                    "Closed by Document No." = const(''));
            RequestFilterFields = "Starting Date", "Seminar No.", "Bill-to Customer No.";

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000);
                if DocDateReq = 0D then
                    Error(Text001);

                Window.Open(
                  Text002 +
                  Text003 +
                  Text004 +
                  Text005);
            end;

            trigger OnAfterGetRecord()
            begin
                if "Bill-to Customer No." <> Cust."No." then begin
                    Cust.get("Bill-to Customer No.");
                    if Cust.Blocked <> Cust.Blocked::" " then begin
                        NoOfSalesInvErrors += 1;
                        CurrReport.Skip();
                    end;
                end;

                if "Bill-to Customer No." <> SalesHeader."Bill-to Customer No." then begin
                    if SalesHeader."No." <> '' then
                        FinalizeSalesInvHeader();
                    InsertSalesInvHeader();
                end;

                SalesLine.Init();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := NextLineNo;
                NextLineNo += 10000;
                SalesLine.Validate(Type, SalesLine.Type::Resource);

                SMBInstructor.Get("Instructor Code");
                SalesLine.Validate("No.", SMBInstructor."Resource No.");
                SalesLine.Description := "Seminar No." + ' ' + "Participant Name";
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", "Unit Price");
                SalesLine."SMB Apply-to Seminar Entry" := "Entry No.";
                SalesLine.Insert(true);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                if SalesHeader."No." <> '' then begin // Not the first time
                    FinalizeSalesInvHeader();
                    if (NoOfSalesInvErrors = 0) and not HideDialog then
                        Message(
                          Text010,
                          NoOfSalesInv)
                    else
                        if not HideDialog then
                            if PostInv then
                                Message(
                                  Text007,
                                  NoOfSalesInvErrors)
                            else
                                Message(
                                  NotAllInvoicesCreatedMsg,
                                  NoOfSalesInvErrors)
                end else
                    if not HideDialog then
                        Message(Text008);
            end;
        }

    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate; PostingDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the posting date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(DocDateReq; DocDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document Date';
                        ToolTip = 'Specifies the document date for the invoice(s) that the batch job creates. This field must be filled in.';
                    }
                    field(CalcInvDisc; CalcInvDisc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Calc. Inv. Discount';
                        ToolTip = 'Specifies if you want the invoice discount amount to be automatically calculated on the shipment.';

                        trigger OnValidate()
                        begin
                            SalesSetup.Get();
                            SalesSetup.TestField("Calc. Inv. Discount", false);
                        end;
                    }
                    field(PostInv; PostInv)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Invoices';
                        ToolTip = 'Specifies if you want to have the invoices posted immediately.';
                    }
                    field(OnlyStdPmtTerms; OnlyStdPmtTerms)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Only Std. Payment Terms';
                        ToolTip = 'Specifies if you want to include shipments with standard payments terms. If you select this option, you must manually invoice all other shipments.';
                    }
                    field(CopyTextLines; CopyTextLines)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy Text Lines';
                        ToolTip = 'Specifies if you want manually written text on the shipment lines to be copied to the invoice.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get();
            CalcInvDisc := SalesSetup."Calc. Inv. Discount";
        end;
    }


    var
        Text000: Label 'Enter the posting date.';
        Text001: Label 'Enter the document date.';
        Text002: Label 'Combining shipments...\\';
        Text003: Label 'Customer No.    #1##########\';
        Text004: Label 'Order No.       #2##########\';
        Text005: Label 'Shipment No.    #3##########';
        Text007: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text008: Label 'There is nothing to combine.';
        Text010: Label 'The shipments are now combined and the number of invoices created is %1.';
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesShptLine: Record "Sales Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        Cust: Record Customer;
        SMBInstructor: Record "SMB Instructor";
        PmtTerms: Record "Payment Terms";
        Language: Codeunit Language;
        SalesCalcDisc: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        Window: Dialog;
        PostingDateReq: Date;
        DocDateReq: Date;
        CalcInvDisc: Boolean;
        PostInv: Boolean;
        OnlyStdPmtTerms: Boolean;
        HasAmount: Boolean;
        HideDialog: Boolean;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        NextLineNo: Integer;
        Text011: Label 'The shipments are now combined, and the number of invoices created is %1.\%2 Shipments with nonstandard payment terms have not been combined.', Comment = '%1-Number of invoices,%2-Number Of shipments';
        NoOfskippedShiment: Integer;
        CopyTextLines: Boolean;
        NotAllInvoicesCreatedMsg: Label 'Not all the invoices were created. A total of %1 invoices were not created.';

    local procedure FinalizeSalesInvHeader()

    begin

        with SalesHeader do begin
            // if (not HasAmount) then begin

            //     Delete(true);

            //     exit;
            // end;

            if CalcInvDisc then
                SalesCalcDisc.Run(SalesLine);
            Find;
            Commit();
            Clear(SalesCalcDisc);
            Clear(SalesPost);
            NoOfSalesInv := NoOfSalesInv + 1;
            if PostInv then begin
                Clear(SalesPost);
                if not SalesPost.Run(SalesHeader) then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
            end;
        end;
    end;

    local procedure InsertSalesInvHeader()
    begin
        Clear(SalesHeader);
        with SalesHeader do begin
            Init;
            "Document Type" := "Document Type"::Invoice;
            "No." := '';

            Insert(true);
            Validate("Sell-to Customer No.", SMBSeminarLedgerEntry."Bill-to Customer No.");
            if "Bill-to Customer No." <> "Sell-to Customer No." then
                Validate("Bill-to Customer No.", SMBSeminarLedgerEntry."Bill-to Customer No.");
            Validate("Posting Date", PostingDateReq);
            Validate("Document Date", DocDateReq);
            // Validate("Currency Code", SalesOrderHeader."Currency Code");
            // Validate("EU 3-Party Trade", SalesOrderHeader."EU 3-Party Trade");
            // "Salesperson Code" := SalesOrderHeader."Salesperson Code";
            // "Shortcut Dimension 1 Code" := SalesOrderHeader."Shortcut Dimension 1 Code";
            // "Shortcut Dimension 2 Code" := SalesOrderHeader."Shortcut Dimension 2 Code";
            // "Dimension Set ID" := SalesOrderHeader."Dimension Set ID";

            Modify;
            Commit();
            HasAmount := false;

            NextLineNo := 0;
        end;


    end;
}