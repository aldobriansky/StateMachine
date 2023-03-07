codeunit 50101 "SM9-Document Publisher"
{
    TableNo = "SM9-Document";

    trigger OnRun()
    var
        Document: Record "SM9-Document";
    begin
        Document.Copy(Rec);
        ProcessDocument(Document);

        Rec.Copy(Document);
    end;

    local procedure ProcessDocument(var Document: Record "SM9-Document")
    var
        StateSequence: Record "SM9-State Sequence";
        xCurrentState: Text[50];
    begin
        if (Document."Next State" = '') or (Document."Next State" = Document."Current State") then
            exit;
        StateSequence.SetRange("Document Type", Document."Document Type");
        StateSequence.SetRange("Current State", Document."Current State");
        if not StateSequence.FindSet() then
            exit;

        StateSequence.SetRange("Current State");
        repeat
            xCurrentState := Document."Current State";
            RaiseEvents(Document, StateSequence);
            if Document."Current State" = xCurrentState then
                exit;
        until (Document."Current State" = Document."Next State") or (StateSequence.Next() = 0);
    end;

    local procedure RaiseEvents(var Document: Record "SM9-Document"; StateSequence: Record "SM9-State Sequence")
    var
        RecordVariant: Variant;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        RecordVariant := Document;

        OnAction01(RecordVariant, StateSequence, IsHandled);
        OnAction02(RecordVariant, StateSequence, IsHandled);
        OnAction03(RecordVariant, StateSequence, IsHandled);
        OnAction04(RecordVariant, StateSequence, IsHandled);
        OnAction05(RecordVariant, StateSequence, IsHandled);
        OnAction06(RecordVariant, StateSequence, IsHandled);
        OnAction07(RecordVariant, StateSequence, IsHandled);
        OnAction08(RecordVariant, StateSequence, IsHandled);
        OnAction09(RecordVariant, StateSequence, IsHandled);
        OnAction10(RecordVariant, StateSequence, IsHandled);

        Document := RecordVariant;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction01(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction02(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction03(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction04(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction05(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction06(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction07(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction08(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction09(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAction10(var RecordVariant: Variant; StateSequence: Record "SM9-State Sequence"; var IsHandled: Boolean)
    begin
    end;
}