@isTest
public class TDF_VariantBAccount extends TDF_SubFactory {
    public override sObject getRecord(Integer index) {
        return new Account(
            Name = 'Variant B' + index
        );
    }
}
