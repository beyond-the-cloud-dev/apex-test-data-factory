Code releted to the post: https://beyondthecloud.dev/blog/apex-test-data-factory

---

## Architecture

![apex test data factory](https://wordpress.beyondthecloud.dev/wp-content/uploads/2022/08/Untitled-Diagram.drawio.png)

![test-data-factory-apex](https://wordpress.beyondthecloud.dev/wp-content/uploads/2022/08/yliYUmaZ2Jut.png)

```java
// TDF_TestDataCreator.cls
public with sharing class TDF_TestDataCreator {
    private final static Map<sObjectType, System.Type> OBJECT_TO_FACTORY = new Map<sObjectType, System.Type>{
        Account.sObjectType => TDF_Accounts.class,
        Contact.sObjectType => TDF_Contacts.class
    };

    public static TDF_SubFactory get(sObjectType objectType, String variant) {
        TDF_Factory objectFactory = (TDF_Factory) OBJECT_TO_FACTORY.get(objectType).newInstance();
        return (TDF_SubFactory) objectFactory.get(variant);
    }
}
```

```java
// TDF_Accounts.cls
public class TDF_Accounts extends TDF_Factory {
  protected override Map<String, System.Type> getVariantToSubFactory() {
    return new Map<String, System.Type>{
      'VARIANT_A' => TDF_AccountVariantA.class,
      'VARIANT_B' => TDF_AccountVariantB.class
    };
  }
}
```

```java
// TDF_AccountVariantA.cls
public with sharing class TDF_AccountVariantA extends TDF_SubFactory {
    public override sObject getRecord(Integer index) {
        return new Account(
            Name = 'Variant A' + index
        );
    }
}
```

## Usage

```java
Account myTestAccount = (Account) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A').create();
Contact myTestContact = (Contact) TDF_TestDataCreator.get(Contact.sObjectType, 'VARIANT_A').withRelatedRecord(myTestAccount).create();

List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A')
																							  .withFieldValue(Account.Name, 'My New Account Name')
																							  .create(5);
```

## Configuration

- `.withFieldValue(sObjectField field, Object value);`


```java
List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A')
							    .withFieldValue(Account.Name, 'My New Account Name')
							    .put(5);
```
**Result**: All Accounts Name will be replaced with **My New Account Name**, no matter of factory configuration.

- `withFieldValuePerRecord(List<Map<sObjectField, Object>> customFieldsValues)`

```java
List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A')
                                                            .withFieldValuePerRecord(new List<Map<sObjectField, Object>>{
							    	new Map<sObjectField, Object>{
									Account.Name => 'My New Account Name 1'
								},
							 	new Map<sObjectField, Object>{
									Account.Name => 'My New Account Name 2'
								}
							      })
                                                              .put(2);
```
**Result**: Each account will have different Name.
accounts[0].Name =>  'My New Account Name 1', accounts[1].Name =>  'My New Account Name 2'

- `withRelatedRecord(sObject relatedRecord)`

```java
Account myTestAccount = (Account) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A').put();
Contact myTestContact = (Contact) TDF_TestDataCreator.get(Contact.sObjectType, 'VARIANT_A').withRelatedRecord(myTestAccount).put();
```

**Result**: **Contact.AccountId** will be taken from **Account.Id** as it is done in SubFactory Mapping (`getMandatoryFields`)

- `put()` and `put(Integer amount)`

```java
Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A').put();

List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A') .put(5);
```

**Result**: Account will be inserted. 5 Accounts will be inserted.

- `get()` and `get(Integer amount)`

```java
Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A').get();

List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, 'VARIANT_A') .get(5);
```

**Result**: Get Account without insert. Get 5 Accounts without insert.

## Benefits
- No class dependencies.
- Single Responsibility Principle - Each `TDF_Factory` and `TDF_SubFactory` are responsible for create specific set of data.
- Open/Close Principle - Easy to add new factories without changing existing code.
- Easy to understand.
- Easy to use.
- Developer don't need to know concrete classes  - invoke `TDF_TestDataCreator`, pass type and variant, get record.

---

If you have some questions feel free to ask in the comment section below. :)

Was it helpful? Check out our other great posts [here](https://beyondthecloud.dev/blog).

---
