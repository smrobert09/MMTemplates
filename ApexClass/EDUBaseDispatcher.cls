global virtual class EB_SObjectDispatcher {
    
    global String typeName                {get;set;}
    global List<SObject> newList          {get;set;}
    global Map<Id, SObject> oldMap        {get;set;}

    /**
     * Initialize the data data type and object collections.
     *
     * @param typeName   The string value of the object type with all '_' characters removed.
     * @param newList    A list of SObjects typically the Trigger.newList values.
     * @param oldMap     A map of SObjects typically equivalent to the Trigger.oldMap values.
     */
    public void initData(String typeName, List<SObject> newList, Map<Id, SObject> oldMap){
        this.typeName = typeName;
        this.newList = newList;
        this.oldMap = oldMap;
    }
    
    /**
     * This method runs prior to any 'before' context methods.  Usually used for data preparation.
     */
    global virtual void prepBefore(){

    }

    /**
     * This method runs prior to any 'after' context methods.  Usually used for data preparation.
     */
    global virtual void prepAfter(){

    }

    /**
     * The before insert functionality placeholder for a generic sObject type.
     */
    global virtual void beforeInsert(){

    }

    /**
     * The after insert functionality placeholder for a generic sObject type.
     */
    global virtual void afterInsert(){
        
    }
    
    /**
     * The before update functionality placeholder for a generic sObject type.
     */
    global virtual void beforeUpdate(){
        
    }

    /**
     * The after update functionality placeholder for a generic sObject type.
     */
    global virtual void afterUpdate(){
        
    }
    
    /**
     * The before delete functionality placeholder for a generic sObject type.
     */
    global virtual void beforeDelete(){

    }
    
    /**
     * The after delete functionality placeholder for a generic sObject type.
     */
    global virtual void afterDelete(){

    }
    
    /**
     * The after undelete functionality placeholder for a generic sObject type.
     */
    global virtual void afterUndelete(){
        
    }

    /**
     * This method runs after to all context methods.  Please not that this will run twice for any DML 
     * action (once on the before context and once on the after context).
     */
    global virtual void andFinally(){

    }
    
    /**
     * Generic execute method accepts the 'context' parameter and processes the required methods accordingly.
     * Control of the methods can be modified by using the EB_TriggerPanel custom setting values.  
     * 
     * If no record is found in the setting for the given sObject, the default behavior is 'true' or run 
     * all methods. Any call to a 'set' function will return false and have no effect.
     *
     * @param  context The context for which to execute the function.
     * @return         
     */
    global virtual void execute(String context){
        if(EB_TriggerPanel.getBreaker(typeName)){
            System.debug('Breaker for ' + typeName + ' set to false. Skipping execution of ' + context + '.');
        }
        System.debug('Beginning execution of ' + context + ' handler.');
        try{

            if(context.contains('before')){
                this.prepBefore();
            }else if(context.contains('after')){
                this.prepAfter();
            }

            if(EB_TriggerPanel.getSwitch(typeName, context)){
                if(context == 'beforeInsert'){
                    this.beforeInsert();
                }else if(context == 'afterInsert'){
                    this.afterInsert();
                }else if(context == 'beforeUpdate'){
                    this.beforeUpdate();
                }else if(context == 'afterUpdate'){
                    this.afterUpdate();
                }else if(context == 'beforeDelete'){
                    this.beforeDelete();
                }else if(context == 'afterDelete'){
                    this.afterDelete();
                }else if(context == 'afterUndelete'){
                    this.afterUndelete();
                }else{
                    //This will never run as the switch always returns false
                    System.debug('No valid context.');
                }
            }else{
                System.debug('Switch for ' + typeName + ':' + context + ' set to false. Skipping execution.');
            }

            this.andFinally();
        }catch(Exception ex){
            if(newList != null){
                for(SObject item:newList){
                  item.addError(ex.getMessage());
                }
            }
            
            System.debug(ex.getTypeName() + ':' + ex.getLineNumber());
            System.debug(ex.getCause());
            System.debug(ex.getStackTraceString());
        }
    }

    /**
     * This method constructs and initializes the proper sObject dispatcher based upon the 
     * data input (newList and oldMap).  The dispatcher is chosen by formula by finding the 
     * sObject type name, removing all '_' characters, prepending 'EB_', and appending 
     * 'Dispatcher'.  For example: My_Custom_Object__c => EB_MyCustomObjectcDispatcher'
     *
     * @param  newList List of sObjects, typically equivalent to Trigger.newList
     * @param  oldMap  Map of sObjects, typically equivalent to Trigger.oldMap
     * @return         
     */
    global static EB_SObjectDispatcher init(List<SObject> newList, Map<Id, SObject> oldMap){
        String typeName;
        if(newList != null && newList.size() > 0){
            typeName = newList[0].getSObjectType().getDescribe().getName();
        }else if(oldMap != null && oldMap.values().size() > 0){
            typeName = oldMap.values()[0].getSObjectType().getDescribe().getName();
        }else{
            typeName = '';
        }

        typeName = typeName.remove('_');

        try{
            System.debug(typeName);
            System.Type t;
            if(Test.isRunningTest()){
                t = Type.forName('SObjectDispatcher');
                if(typeName == 'TriggerPanelc'){
                    throw new SObjectException('Triggers are not supported on TriggerPanelc object');
                }
            }else{
                t = Type.forName('EB_' + typeName + 'Dispatcher');
            }
            System.debug(t);

            EB_SObjectDispatcher dispatch;
            if(t != null){
                dispatch = (EB_SObjectDispatcher) t.newInstance();
                dispatch.initData(typeName, newList, oldMap);
                return dispatch;
            }
        }catch(Exception ex){
            System.debug(ex.getTypeName() + ':' + ex.getLineNumber());
            System.debug(ex.getCause());
            System.debug(ex.getStackTraceString());
        }

        return null;
    }
}