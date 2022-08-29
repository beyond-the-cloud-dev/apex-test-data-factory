@isTest
public class TDF_Configuration {
    public Map<sObjectField, Object> allRecordsFieldValues = new Map<sObjectField, Object>();
    public Map<sObjectType, List<sObject>> relatedObjectFieldValues = new Map<sObjectType, List<sObject>>();
    public List<Map<sObjectField, Object>> customFieldsValues = new List<Map<sObjectField, Object>>();
    public Integer recordAmount = 1;

    private TDF_SubFactory subFactory;

    private Integer relatedRecordsIterationIndex = 0;
    private Integer customValuesIterationIndex = 0;

    public TDF_Configuration(TDF_SubFactory subFactory) {
        this.subFactory = subFactory;
    }

    public List<sObject> build() {
        List<sObject> recordsToCreate = new List<sObject>();

        for (Integer i = 0; i < this.recordAmount; i++) {
            sObject recordToCreate = this.subFactory.getRecord(i);

            fillRecordWithGlobalFieldValues(recordToCreate);
            fillRecordWithRelatedObjectFieldValues(recordToCreate);
            fillRecordWithCustomFieldValues(recordToCreate);

            recordsToCreate.add(recordToCreate);
        }

        return recordsToCreate;
    }

    private void fillRecordWithGlobalFieldValues(sObject recordToCreate) {
        for (sObjectField field : this.allRecordsFieldValues.keySet()) {
            recordToCreate.put(field, this.allRecordsFieldValues.get(field));
        }
    }

    private void fillRecordWithRelatedObjectFieldValues(sObject recordToCreate) {
        if (this.relatedObjectFieldValues.isEmpty()) {
            return;
        }

        Map<sObjectType, Map<sObjectField, sObjectField>> relatedObjectMapping = this.subFactory.getMandatoryFields();

        for (sObjectType relatedObjectType : relatedObjectMapping.keySet()) {
            Map<sObjectField, sObjectField> destinationToSourceFields = relatedObjectMapping.get(relatedObjectType);

            List<sObject> relatedObjectValues = this.relatedObjectFieldValues.get(relatedObjectType);

            if (this.relatedRecordsIterationIndex >= relatedObjectValues.size()) {
                this.relatedRecordsIterationIndex = 0; // Start filling from begining
            }

            for (sObjectField destinationField : destinationToSourceFields.keySet()) {
                sObjectField sourceField = destinationToSourceFields.get(destinationField);
                sObject relatedRecord = relatedObjectValues.get(this.relatedRecordsIterationIndex);

                recordToCreate.put(destinationField, relatedRecord.get(sourceField));
            }
        }

        this.relatedRecordsIterationIndex++;
    }

    private void fillRecordWithCustomFieldValues(sObject recordToCreate) {
        if (this.customFieldsValues.isEmpty()) {
            return;
        }

        if (this.customValuesIterationIndex >= this.customFieldsValues.size()) {
            this.customValuesIterationIndex = 0; // Start filling from begining
        }

        Map<sObjectField, Object> fieldToValue = this.customFieldsValues[this.customValuesIterationIndex];

        for (sObjectField destinationField : fieldToValue.keySet()) {
            recordToCreate.put(destinationField, fieldToValue.get(destinationField));
        }

        this.customValuesIterationIndex++;
    }
}
