@isTest
public class TDF_VariantAAccount extends TDF_SubFactory {
    public override sObject getRecord(Integer index) {
        return new Account(
            Name = 'Variant A' + index
        );
    }
}
