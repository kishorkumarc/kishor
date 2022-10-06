public class opportunitytriggerhandler {

//1.requirement is whenever the opportunity is inserted then related account Annual revenue should be updated.
//2.when opportunity amount is updated then related account annual revenue should be updated.
//3.when opportunity is deleted then account annual revenue should be reduced.

    
    public static void afterinsert(List<opportunity>optylist){
        
        List<account>accountlistupdate=new List<Account>();
        set<id>accountids=new set<id>();
        for(opportunity op:optylist){
            if(op.accountid!=null){
                accountids.add(op.accountid);
            }
        }
        accountlistupdate=Annualrevenuecalculate(accountids);
        
        if(!accountlistupdate.isEmpty()){
            update accountlistupdate;
        }
    }
     public static void afterupdate(List<opportunity>optylist, map<id,opportunity>oldmap){
        
        List<account>accountlistupdate=new List<Account>();
        set<id>accountids=new set<id>();
        for(opportunity op:optylist){
            if(op.accountid!=null && oldmap!=null && op.Amount != oldmap.get(op.id).Amount){
                accountids.add(op.accountid);
            }
        }
        accountlistupdate=Annualrevenuecalculate(accountids);
        
        if(!accountlistupdate.isEmpty()){
            update accountlistupdate;
        }
    }
    
    public static List<Account> Annualrevenuecalculate(set<id>accountids){
        List<Account>acctobeupdated=new List<Account>();
         map<id,Decimal>accidAnnualrevenue=new map<id,Decimal>();
        for(opportunity op:[select id,Accountid,Amount from opportunity where accountid IN:accountids]){
            Decimal total=0;
            // initially it will zero for account so thats why i am using.
            if(accidAnnualrevenue.containskey(op.AccountId)){
                total=accidAnnualrevenue.get(op.AccountId);
            }
            if(op.Amount!=null){
                total= total + op.amount;
            }
            accidAnnualrevenue.put(op.AccountId,total);
        }
        
        if(!accidAnnualrevenue.isEmpty()){
            for(Id i:accidAnnualrevenue.keyset()){
                account acc=new account();
                acc.id=i;
                acc.AnnualRevenue=accidAnnualrevenue.get(i);
                acctobeupdated.add(acc);
            }
			}
             return acctobeupdated;

    }
}