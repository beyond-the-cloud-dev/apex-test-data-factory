@isTest
public class TDF_Accounts extends TDF_Factory {
    public override System.Type getDefaultVariation() {
        return TDF_VariantAAccount.class;
    }

    public override Map<String, System.Type> getVariantToSubFactory() {
        return new Map<String, System.Type>{
          TDF_Consts.ACCOUNT.VARIANT.A => TDF_VariantAAccount.class,
          TDF_Consts.ACCOUNT.VARIANT.B => TDF_VariantBAccount.class
        };
    }
}
