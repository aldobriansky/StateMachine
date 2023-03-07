table 50105 "SM9-Document"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "SM9-Document Types")
        {

        }
        field(2; "Record ID"; RecordId)
        {

        }
        field(10; "Current State"; Text[50])
        {

        }
        field(20; "Next State"; Text[50])
        {

        }
        field(700; "Last Error"; Text[2048])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Record ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}