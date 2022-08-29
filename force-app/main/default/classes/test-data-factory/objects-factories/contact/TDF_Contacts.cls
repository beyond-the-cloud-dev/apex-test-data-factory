@isTest
public class TDF_Contacts extends TDF_Factory {
  public override System.Type getDefaultVariation() {
    return TDF_VariantCContact.class;
  }

  public override Map<String, System.Type> getVariantToSubFactory() {
    return new Map<String, System.Type>{
      TDF_Consts.CONTACT.VARIANT.C => TDF_VariantCContact.class,
      TDF_Consts.CONTACT.VARIANT.D => TDF_VariantDContact.class,
      TDF_Consts.CONTACT.VARIANT.E => TDF_VariantFContact.class
    };
  }
}
