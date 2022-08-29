@isTest
public class TDF_VariantCContact extends TDF_SubFactory {
    public override Map<sObjectType, Map<sObjectField, sObjectField>> getMandatoryFields() {
        return new Map<sObjectType, Map<sObjectField, sObjectField>>{
            Account.sObjectType => new Map<sObjectField, sObjectField>{
                Contact.AccountId => Account.Id
            }
        };
    }

    public override sObject getRecord(Integer index) {
        return new Contact(
            FirstName = 'First Name C' + index,
            LastName = 'Last Name C' + index
        );
    }
}
