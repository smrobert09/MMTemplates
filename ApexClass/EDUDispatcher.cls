public class {{ api_name }} extends EB_SObjectDispatcher {
    
    /**
     * The before insert functionality on the {{ object_name }} object
     *
     * @return 
     */
    public override void beforeInsert(){
        System.debug('Overriden');
    }

    /**
     * Utility method to transform the Trigger.newList to the appropriate SObject type.
     *
     * @return A list containing the new {{ object_name }} objects.
     */
    public List<{{ object_name }}> getNewList(){
    	if(newList != null){
    		return (List<{{ object_name }}>) newList;
    	}
    	return null;
    }

    /**
     * Utility method to transform the Trigger.oldMap into the appropriate SObject type.
     *
     * @return A map containing the old {{ object_name }} objects by Id.
     */
    public Map<Id, {{ object_name }}> getOldMap(){
    	if(oldMap != null){
	    	Map<Id, {{ object_name }}> oMap = new Map<Id, {{ object_name }}>();
            oMap.putAll( (List<{{ object_name }}>) oldMap.values());
            return oMap;
    	}
    	return null;
    }

    /**
     * Utility method to transform the Trigger.newList to a map of the appropriate SObject type.
     *
     * @return A map containing the new {{ object_name }} objects by Id.
     */
    public Map<Id, {{ object_name }}> getNewMap(){
    	if(newList != null){
    		Map<Id, {{ object_name }}> newMap = new Map<Id, {{ object_name }}>();
			newMap.putAll(getNewList()); 
    		return  newMap;
    	}
    	return null;
    }

}