public class triggerhandler {
    
    public static void beforeupdatehandler(List<account>acclist,map<id,Account>oldmap){
        
        for(Account acc:acclist){
            if(oldmap!=null && acc.phone != oldmap.get(acc.id).phone){
                acc.description='phone updated';
            }
        }
    }
    
    public static void afterupdatehandler(List<Account>acclist,map<id,Account>oldmap){
            map<id,Account>acmap=new map<id,Account>();
        for(Account acc:acclist){
            if(oldmap!=null && acc.Phone!=oldmap.get(acc.id).phone){
                acmap.put(acc.id,acc);
            }
        }
        List<contact>conlist=new List<contact>();
        for(contact con:[select id,phone,accountid from contact where accountid IN :acmap.keyset()]){
            contact conupd=new contact();
            if(acmap.containskey(con.AccountId)){
                system.debug('inside acmap check ');
                conupd.Id=con.Id;
                conupd.Phone=acmap.get(con.AccountId).phone;
                conlist.add(conupd);
            }
        }
        
        if(!conlist.isEmpty()){
            system.debug('inside update list');
            update conlist;
        }
    }
    

}