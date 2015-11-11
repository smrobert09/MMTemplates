trigger {{ object_name }}Trigger on {{ object_name }} (	before insert,	before update,	before delete, after insert,	after update,	after delete, after undelete) {

	EB_SObjectDispatcher dispatch = EB_SObjectDispatcher.init(Trigger.new, Trigger.oldMap);

	if(Trigger.isInsert){
		if(Trigger.isBefore){
			dispatch.execute('beforeInsert');
        }
        if(Trigger.isAfter){
        	dispatch.execute('afterInsert');
    	}
	}
	if(Trigger.isUpdate){
		if(Trigger.isBefore){
			dispatch.execute('beforeUpdate');
        }
        if(Trigger.isAfter){
        	dispatch.execute('afterUpdate');
    	}
	}
	if(Trigger.isDelete){
		if(Trigger.isBefore){
			dispatch.execute('beforeDelete');
        }
        if(Trigger.isAfter){
        	dispatch.execute('afterDelete');
    	}
	}
	if(Trigger.isUndelete){
        if(Trigger.isAfter){
        	dispatch.execute('afterUndelete');
    	}
	}

}