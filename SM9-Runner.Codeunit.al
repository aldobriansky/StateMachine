codeunit 50111 "SM9-Runner"
{

    TableNo = "SM9-Document";

    trigger OnRun()
    var
        Document: Record "SM9-Document";
        Publisher: Codeunit "SM9-Document Publisher";
        Subscriber: Codeunit "SM9-Subscriber";
    begin
        BindSubscription(Subscriber);

        Document.Copy(Rec);
        if Document.FindSet() then
            repeat
                if Publisher.Run(Document) then
                    Document."Last Error" := ''
                else
                    Document."Last Error" := GetLastErrorText();
                Document.Modify();
                Commit();
            until Document.Next() = 0;
        Rec.Copy(Document);

        UnbindSubscription(Subscriber);
    end;

    procedure CreatePurchaseDocuments()
    var
        Document: Record "SM9-Document";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Item: Record Item;
        Location: Record Location;
        WarehouseEmployee: Record "Warehouse Employee";
        LibraryInventory: Codeunit "Library - Inventory";
        LibraryWarehouse: Codeunit "Library - Warehouse";
        LibraryPurchase: Codeunit "Library - Purchase";
        i: Integer;
    begin
        Document.SetRange("Document Type", Document."Document Type"::Purchase);
        Document.DeleteAll();

        LibraryInventory.CreateItem(Item);
        LibraryWarehouse.CreateLocationWMS(Location, false, false, false, true, false);
        LibraryWarehouse.CreateWarehouseEmployee(WarehouseEmployee, Location.Code, false);
        for i := 1 to 5 do begin
            LibraryPurchase.CreatePurchaseDocumentWithItem(
              PurchaseHeader, PurchaseLine, PurchaseHeader."Document Type"::Order, '', Item."No.", 10 * i, Location.Code, WorkDate());

            Document.Init();
            Document."Document Type" := "SM9-Document Types"::Purchase;
            Document."Record ID" := PurchaseHeader.RecordId;
            Document."Current State" := Format(PurchaseHeader.Status);
            Document.Insert();
        end;
    end;

    procedure CreateStateSequenceForPurchase()
    var
        StateSequence: Record "SM9-State Sequence";
    begin
        StateSequence.SetRange("Document Type", "SM9-Document Types"::Purchase.AsInteger());
        StateSequence.DeleteAll();

        StateSequence."Entry No." := 1;
        StateSequence."Document Type" := "SM9-Document Types"::Purchase.AsInteger();
        StateSequence."Document No." := '';
        StateSequence."Operation No." := 10;
        StateSequence."Current State" := 'Open';
        StateSequence."Next State" := 'Released';
        StateSequence."Event Subscriber" := 'OnReleasePurchaseOrder';
        StateSequence.Insert();

        StateSequence."Entry No." := 2;
        StateSequence."Document Type" := "SM9-Document Types"::Purchase.AsInteger();
        StateSequence."Document No." := '';
        StateSequence."Operation No." := 20;
        StateSequence."Current State" := 'Released';
        StateSequence."Next State" := 'Sent to warehouse';
        StateSequence."Event Subscriber" := 'OnPostWarehouseReceiptForPurchase';
        StateSequence.Insert();

        StateSequence."Entry No." := 3;
        StateSequence."Document Type" := "SM9-Document Types"::Purchase.AsInteger();
        StateSequence."Document No." := '';
        StateSequence."Operation No." := 30;
        StateSequence."Current State" := 'Sent to warehouse';
        StateSequence."Next State" := 'Invoiced';
        StateSequence."Event Subscriber" := 'OnInvoicePurchaseOrder';
        StateSequence.Insert();
    end;
}