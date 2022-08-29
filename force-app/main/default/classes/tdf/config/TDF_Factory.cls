public abstract class TDF_Factory {
  public abstract Map<String, System.Type> getVariantToSubFactory();
  public abstract System.Type getDefaultVariation();

  public TDF_SubFactory get(String variant) {
    return (TDF_SubFactory) this.getVariantToSubFactory().get(variant).newInstance();
  }
}
