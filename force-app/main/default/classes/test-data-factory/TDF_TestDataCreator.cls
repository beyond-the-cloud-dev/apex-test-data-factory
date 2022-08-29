@isTest
public class TDF_TestDataCreator {
    private final static Map<sObjectType, System.Type> OBJECT_TO_FACTORY = new Map<sObjectType, System.Type>{
        Account.sObjectType => TDF_Accounts.class,
        Contact.sObjectType => TDF_Contacts.class
    };

    public static TDF_SubFactory get(sObjectType objectType) {
        return (TDF_SubFactory) getObjectFactory(objectType).getDefaultVariation().newInstance();
    }

    public static TDF_SubFactory get(sObjectType objectType, String variant) {
        return (TDF_SubFactory) getObjectFactory(objectType).get(variant);
    }

    private static TDF_Factory getObjectFactory(sObjectType objectType) {
        return (TDF_Factory) OBJECT_TO_FACTORY.get(objectType).newInstance();
    }
}
