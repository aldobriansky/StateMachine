page 50149 "SM9-Start Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SM9-Document";

    layout
    {
        area(Content)
        {
            repeater(Documents)
            {
                field("Document Type"; Rec."Document Type")
                {

                }
                field("Document No."; DocumentNo)
                {

                }
                field("Current State"; Rec."Current State")
                {

                }
                field("Next State"; Rec."Next State")
                {
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        StateSequence: Record "SM9-State Sequence";
                    begin
                        StateSequence.SetRange("Document Type", Rec."Document Type");
                        if Page.RunModal(Page::"SM9-Sequences", StateSequence) = Action::LookupOK then
                            Rec."Next State" := StateSequence."Next State";
                    end;
                }
                field("Last Error"; Rec."Last Error")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Purchase Order")
            {
                ApplicationArea = All;

                trigger OnAction();
                var
                    PurchaseHeader: Record "Purchase Header";
                begin
                    PurchaseHeader.Get(Rec."Record ID");
                    Page.Run(Page::"Purchase Order", PurchaseHeader);
                end;
            }
            action("State Sequence")
            {
                ApplicationArea = All;
                RunObject = page "SM9-Sequences";
            }
            action("Create Demo Data")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Runner: Codeunit "SM9-Runner";
                begin
                    Runner.CreatePurchaseDocuments();
                    Runner.CreateStateSequenceForPurchase();
                    CurrPage.Update(false);
                end;
            }
            action(Run)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Document: Record "SM9-Document";
                begin
                    CurrPage.SetSelectionFilter(Document);
                    Codeunit.Run(Codeunit::"SM9-Runner", Document);

                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        DocumentNo: Code[20];

    trigger OnAfterGetRecord()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        DocumentNo := '';
        if PurchaseHeader.Get(Rec."Record ID") then
            DocumentNo := PurchaseHeader."No.";
    end;
}