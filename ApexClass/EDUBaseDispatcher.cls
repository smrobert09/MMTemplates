public virtual class EB_SObjectDispatcher {
    public List<SObject> newList {get;set;}
    public Map<Id, SObject> oldMap {get;set;}

    public Boolean runBeforeInsert = true;
    public Boolean runBeforeUpdate = true;
    public Boolean runBeforeDelete = true;
    public Boolean runAfterInsert = true;
    public Boolean runAfterUpdate = true;
    public Boolean runAfterDelete = true;
    public Boolean runAfterUndelete = true;

    public EB_SObjectDispatcher(){

    }

    public void initData(List<SObject> nList, Map<Id, SObject> oMap){
        newList = nList;
        oldMap = oMap;
    }
    
    public virtual void beforeInsert(){
        System.debug('Not overridden');
    }

    public virtual void afterInsert(){
        
    }
    
    public virtual void beforeUpdate(){
        
    }

    public virtual void afterUpdate(){
        
    }
    
    public virtual void beforeDelete(){

    }
    
    public virtual void afterDelete(){

    }
    
    public virtual void afterUndelete(){
        
    }
    
    public virtual void execute(String context){
        System.debug('Starting to execute ' + context + '.');
        //Savepoint sp = Database.setSavepoint();
        try{
            if(context == 'beforeInsert' && runBeforeInsert){
                beforeInsert();
            }else if(context == 'afterInsert' && runAfterInsert){
                afterInsert();
            }else if(context == 'beforeUpdate' && runBeforeUpdate){
                beforeUpdate();
            }else if(context == 'afterUpdate' && runAfterUpdate){
                afterUpdate();
            }else if(context == 'beforeDelete' && runBeforeDelete){
                beforeDelete();
            }else if(context == 'afterDelete' && runAfterDelete){
                afterDelete();
            }else if(context == 'afterUndelete' && runAfterUndelete){
                afterUndelete();
            }else{
                System.debug('No valid context.');
            }
        }catch(Exception ex){
            if(newList != null){
                for(SObject item:newList){
                  item.addError(ex.getMessage());
                }
            }
            if(oldMap != null){
                for(SObject item:oldMap.values()){
                  item.addError(ex.getMessage());
                }
            }
            
            System.debug(ex.getTypeName() + ':' + ex.getLineNumber());
            System.debug(ex.getCause());
            System.debug(ex.getStackTraceString());
            
            //Database.rollback(sp);
        }
    }

    public static EB_SObjectDispatcher init(List<SObject> nList, Map<Id, SObject> oMap){
        String typeName;
        if(nList != null && nList.size() > 0){
            typeName = nList[0].getSObjectType().getDescribe().getName();
        }else if(oMap != null && oMap.values().size() > 0){
            typeName = oMap.values()[0].getSObjectType().getDescribe().getName();
        }
        typeName = typeName.remove('__c').remove('_');

        System.debug(typeName);
        System.Type t = Type.forName('EB_' + typeName + 'Dispatcher');
        System.debug(t);

        EB_SObjectDispatcher dispatch;
        if(t != null){
            dispatch = (EB_SObjectDispatcher) t.newInstance();
            dispatch.initData(nList, oMap);
            return dispatch;
        }
        return null;
    }
}