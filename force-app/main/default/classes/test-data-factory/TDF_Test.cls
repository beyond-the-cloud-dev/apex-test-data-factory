@isTest
public class TDF_Test {
    @isTest
    static void getDefaultSimpleRecordTest() {
        Test.startTest();
        Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType).get();
        Test.stopTest();

        System.assertNotEquals(null, account, 'Account should be created.');
    }

    @isTest
    static void getSimpleRecordTest() {
        Test.startTest();
        Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).get();
        Test.stopTest();

        System.assertNotEquals(null, account, 'Account should be created.');
    }

    @isTest
    static void getMultipleRecordsTest() {
        Integer recordsAmount = 5;

        Test.startTest();
        List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).get(recordsAmount);
        Test.stopTest();

        System.assertEquals(recordsAmount, accounts.size(), '5 Account should be created.');
    }

    @isTest
    static void getSimpleRecordWithCustomFieldValueForAllTest() {
        String customAccountName = 'My Custom Name Value';

        Test.startTest();
        Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).withFieldValue(Account.Name, customAccountName).get();
        Test.stopTest();

        System.assertNotEquals(null, account, 'Account should be created.');
        System.assertEquals(customAccountName, account.Name, 'Account Name should be overriden.');
    }

    @isTest
    static void getMultipleRecordWithCustomFieldValueForAllTest() {
        Integer recordsAmount = 5;
        String customAccountName = 'My Custom Name Value';

        Test.startTest();
        List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).withFieldValue(Account.Name, customAccountName).get(recordsAmount);
        Test.stopTest();

        System.assertEquals(recordsAmount, accounts.size(), '5 Account should be created.');
        for (Account createdAccount : accounts) {
            System.assertEquals(customAccountName, createdAccount.Name, 'Account Name should be overriden.');
        }
    }

    @isTest
    static void getSimpleRecordWithCustomFieldsValuesTest() {
        String customAccountName = 'My Custom Name Value';

        Test.startTest();
        Account account = (Account) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A)
            .withFieldValuePerRecord(new List<Map<sObjectField, Object>>{ new Map<sObjectField, Object>{ Account.Name => customAccountName } })
            .get();
        Test.stopTest();

        System.assertNotEquals(null, account, 'Account should be created.');
        System.assertEquals(customAccountName, account.Name, 'Account Name should be overriden.');
    }

    @isTest
    static void getMultipleRecordWithCustomFieldsValuesTest() {
        Integer recordsAmount = 5;
        String customAccountName = 'My Custom Name Value';

        Test.startTest();
        List<Account> accounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A)
            .withFieldValuePerRecord(new List<Map<sObjectField, Object>>{ new Map<sObjectField, Object>{ Account.Name => customAccountName } })
            .get(recordsAmount);
        Test.stopTest();

        System.assertEquals(recordsAmount, accounts.size(), '5 Account should be created.');
        for (Account createdAccount : accounts) {
            System.assertEquals(customAccountName, createdAccount.Name, 'Account Name should be overriden.');
        }
    }

    @isTest
    static void getSimpleRecordWithValuesFromRelatedObjectTest() {
        Test.startTest();
        Account createdAccount = (Account) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).get();
        Contact createdContact = (Contact) TDF_TestDataCreator.get(Contact.sObjectType, TDF_Consts.CONTACT.VARIANT.C).withRelatedRecord(createdAccount).get();
        Test.stopTest();

        System.assertNotEquals(null, createdAccount, 'Account should be created.');
        System.assertNotEquals(null, createdContact, 'Contact should be created.');
        System.assertEquals(createdAccount.Name, createdContact.LastName, 'Contact should have the same name as Account.');
    }

    @isTest
    static void getMultipleRecordsWithValuesFromRelatedObjectTest() {
        Integer recordsAmount = 5;

        Test.startTest();
        List<Account> createdAccounts = (List<Account>) TDF_TestDataCreator.get(Account.sObjectType, TDF_Consts.ACCOUNT.VARIANT.A).get(recordsAmount);
        List<Contact> createdContacts = (List<Contact>) TDF_TestDataCreator.get(Contact.sObjectType, TDF_Consts.CONTACT.VARIANT.C).withRelatedRecords(createdAccounts).get(recordsAmount);
        Test.stopTest();

        System.assertEquals(recordsAmount, createdAccounts.size(), '5 Accounts should be created.');
        System.assertEquals(recordsAmount, createdContacts.size(), '5 Contacts should be created.');

        for (Integer i = 0; i < recordsAmount; i++) {
            System.assertEquals(createdAccounts[i].Name, createdContacts[i].LastName, 'Contact Name should be overriden.');
        }
    }
}
