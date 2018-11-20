admin username: admin@admin
password: admin

Log-in via google has been implemented. 
Househuntersx will receive mail when a reply is provided by realtor.

Few things to note: 
1. Admin can not create houses or inquiries, but he can edit and destroy them. 
    Letting admin create houses causes instability with other operations (like: Where should interested list be shown? and similar functionalities)
2. Interest in house and inquiries can be posted by house hunter while looking at an individual house. He can opt out of being interested in the house from same page.
3. If a user registers for househunter and realtor with same email but different passwords, the latest password entered will be used.
4. The relationships are implemented, even if some of them are missing from model files. Please refer schema.rb.


Edge Cases:

1. On deleting a user, the corresponding househunter and realtor accounts are deleted.
2. On deleting a company, corresponding houses are deleted and realtors with that company have their company set to null
3. on deleting a househunter or house, the corresponding entry in interest list is deleted.
4. On deleting househunter or house, corresponding inquiry is deleted

