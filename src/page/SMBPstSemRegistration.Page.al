page 123456734 "SMB Pst. Sem. Registration"
{
    // CSD1.00 - 2013-04-03 - D. E. Veloper
    //   Chapter 4 - Lab 3
    //     - Created new page

    Caption = 'Pst. Seminar Registration';
    Editable = false;
    PageType = Document;
    SourceTable = "SMB Posted Seminar Reg. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    ApplicationArea = All;
                }
                field("Starting Date"; "Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field';
                    ApplicationArea = All;
                }
                field("Seminar No."; "Seminar No.")
                {
                    ToolTip = 'Specifies the value of the Seminar No. field';
                    ApplicationArea = All;
                }
                field("Seminar Description"; "Seminar Description")
                {
                    ToolTip = 'Specifies the value of the Seminar Description field';
                    ApplicationArea = All;
                }
                field("Duration Days"; "Duration Days")
                {
                    ToolTip = 'Specifies the value of the Duration (Days) field';
                    ApplicationArea = All;
                }
                field("Instructor Code"; "Instructor Code")
                {
                    ToolTip = 'Specifies the value of the Instructor Code field';
                    ApplicationArea = All;
                }
                field("Instructor Name"; "Instructor Name")
                {
                    ToolTip = 'Specifies the value of the Instructor Name field';
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field';
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field';
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    ApplicationArea = All;
                }
                field("Minimum Participants"; "Minimum Participants")
                {
                    ToolTip = 'Specifies the value of the Minimum Participants field';
                    ApplicationArea = All;
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                    ToolTip = 'Specifies the value of the Maximum Participants field';
                    ApplicationArea = All;
                }
                field("Language Code"; "Language Code")
                {
                    ToolTip = 'Specifies the value of the Language Code field';
                    ApplicationArea = All;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                    ToolTip = 'Specifies the value of the Salesperson Code field';
                    ApplicationArea = All;
                }
            }
            part(SeminarRegistrationLines; "SMB Pst. Sem. Reg. Subpage")
            {
                Caption = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Seminar Room")
            {
                Caption = 'Seminar Room';
                field("Room Code"; "Room Code")
                {
                    ToolTip = 'Specifies the value of the Room Code field';
                    ApplicationArea = All;
                }
                field("Room Name"; "Room Name")
                {
                    ToolTip = 'Specifies the value of the Name field';
                    ApplicationArea = All;
                }
                field("Room Name 2"; "Room Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field';
                    ApplicationArea = All;
                }
                field("Room Address"; "Room Address")
                {
                    ToolTip = 'Specifies the value of the Address field';
                    ApplicationArea = All;
                }
                field("Room Address 2"; "Room Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field';
                    ApplicationArea = All;
                }
                field("Room Post Code"; "Room Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field';
                    ApplicationArea = All;
                }
                field("Room City"; "Room City")
                {
                    ToolTip = 'Specifies the value of the City field';
                    ApplicationArea = All;
                }
                field("Room Country/Region Code"; "Room Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field';
                    ApplicationArea = All;
                }
                field("Room County"; "Room County")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the County field';
                    ApplicationArea = All;
                }
                field("Room Contact"; "Room Contact")
                {
                    ToolTip = 'Specifies the value of the Contact field';
                    ApplicationArea = All;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Seminar Price"; "Seminar Price")
                {
                    ToolTip = 'Specifies the value of the Seminar Price field';
                    ApplicationArea = All;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field';
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies the value of the VAT Prod. Posting Group field';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control29; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control30; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "SMB Seminar Comment Sheet";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = WHERE("Document Type" = CONST("Posted Seminar Registration"));
                    ToolTip = 'Executes the Co&mments action';
                    ApplicationArea = All;
                }
                action("&Charges")
                {
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page "SMB Posted Seminar Charges";
                    ToolTip = 'Executes the &Charges action';
                    ApplicationArea = All;
                    //  RunPageLink = "Document No." = FIELD ("No.");
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Navigate();
                end;
            }
        }
    }
}

