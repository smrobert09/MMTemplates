global class EB_TriggerPanel {

    @testVisible
    private static Map<String, Trigger_Panel__c> panelMap;
    
    /**
     * Global accessor for single TriggerPanel records. If no record is found, a default
     * is created with breaker and switches set to true.
     */
    global static Trigger_Panel__c getPanel(String typeName){
        if(getAllPanels().containsKey(typeName) == false){
            Trigger_Panel__c panel = new Trigger_Panel__c();
            panel.Name = typeName;
            panel.Breaker__c = true;
            getAllPanels().put(typeName, panel);
            setAllSwitches(typeName, true);
        }
        return getAllPanels().get(typeName);
    }

    /**
     * Global accessor for TriggerPanel records.
     */
    global static Map<String, Trigger_Panel__c> getAllPanels(){
        if(panelMap == null){
            panelMap = new Map<String, Trigger_Panel__c>(Trigger_Panel__c.getAll());
        }
        return panelMap;
    }
    
    /**
     * Returns the related value of the EB_TriggerPanel record for the given context.  If there is
     * no record for the object type, and no sets are called previously in the code, the default
     * return is true.
     *
     * @param typeName The string value of the object type with all '_' characters removed.
     * @param context  The trigger context value with no spaces.  For example, 'beforeInsert'.
     * @return         The return value indicates whether the trigger switch is set to on or off.
     */
    global static Boolean getSwitch(String typeName, String context){
        return (Boolean) getPanel(typeName).get(context + '__c');
    }

    /**
     * Sets the related value of the EB_TriggerPanel record for the given context. If there is no
     * record in the database for this sObject type, a temporary record (all options set to true 
     * by default) will be created for this transaction only. The supplied value will then be set.
     *
     * @param  typeName The string value of the object type with all '_' characters removed.
     * @param  context  The trigger context value with no spaces.  For example, 'beforeInsert'.
     * @param  active   The desired value to set.
     */
    global static void setSwitch(String typeName, String context, Boolean active){
        getPanel(typeName).put(context + '__c', active);
    }

    /**
     * Returns the breaker value of the EB_TriggerPanel record.
     *
     * @param typeName The string value of the object type with all '_' characters removed.
     * @return         The return value indicates whether the trigger breaker is set to on or off.
     */
    global static Boolean getBreaker(String typeName){
        return getPanel(typeName).Breaker__c;
    }

    /**
     * Sets the breaker value of the EB_TriggerPanel record.  If there is no record in the 
     * database for this sObject type, a temporary record (all options set to true by default) 
     * will be created for this transaction only. The supplied value will then be set.
     *
     * @param  typeName The string value of the object type with all '_' characters removed.
     * @param  active   The desired value to set.
     */
    global static void setBreaker(String typeName, Boolean active){
        getPanel(typeName).Breaker__c = active;
    }

    /**
     * Sets the related value of the EB_TriggerPanel record for all contexts. If there is no 
     * record in the database for this sObject type, a temporary record (all options set to 
     * true by default) will be created for this transaction only. The supplied value will 
     * then be set.
     *
     * @param  typeName The string value of the object type with all '_' characters removed.
     * @param  active   The desired value to set.
     * @return          The return value indicates successful update (this transaction only).
     */
    global static void setAllSwitches(String typeName, Boolean active){
        Trigger_Panel__c panel = getPanel(typeName);
        panel.BeforeInsert__c = active;
        panel.AfterInsert__c = active;
        panel.BeforeUpdate__c = active;
        panel.AfterUpdate__c = active;
        panel.BeforeDelete__c = active;
        panel.AfterDelete__c = active;
        panel.AfterUndelete__c = active;
    }
}