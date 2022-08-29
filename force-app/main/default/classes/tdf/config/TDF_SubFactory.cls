public abstract class TDF_SubFactory {
    private TDF_Configuration configuration;

    public abstract sObject getRecord(Integer index);

    public virtual Map<sObjectType, Map<sObjectField, sObjectField>> getMandatoryFields() {
        return new Map<sObjectType, Map<sObjectField, sObjectField>>();
    }

    public TDF_SubFactory() {
        this.configuration = new TDF_Configuration(this);
    }

    public TDF_SubFactory withFieldValue(sObjectField field, Object value) {
        this.configuration.allRecordsFieldValues.put(field, value);
        return this;
    }

    public TDF_SubFactory withFieldValuePerRecord(List<Map<sObjectField, Object>> customFieldsValues) {
        this.configuration.customFieldsValues = customFieldsValues;
        return this;
    }

    public TDF_SubFactory withRelatedRecord(sObject relatedRecord) {
        this.configuration.relatedObjectFieldValues.put(relatedRecord.getSObjectType(), new List<sObject>{ relatedRecord });
        return this;
    }

    public TDF_SubFactory withRelatedRecords(List<sObject> relatedRecords) {
        if (relatedRecords.isEmpty()) {
            return this;
        }
        this.configuration.relatedObjectFieldValues.put(relatedRecords[0].getSObjectType(), relatedRecords);
        return this;
    }

    public sObject put() {
        return this.put(1)[0];
    }

    public sObject get() {
        return this.get(1)[0];
    }

    public List<sObject> get(Integer recordAmount) {
        this.configuration.recordAmount = recordAmount;
        return this.createAndInsert(true);
    }

    public List<sObject> put(Integer recordAmount) {
        this.configuration.recordAmount = recordAmount;
        return this.createAndInsert(false);
    }

    private List<sObject> createAndInsert(Boolean insertRecord) {
        List<sObject> recordsToCreate = this.configuration.build();

        if (insertRecord) {
            insert recordsToCreate;
        }

        return recordsToCreate;
    }
}
