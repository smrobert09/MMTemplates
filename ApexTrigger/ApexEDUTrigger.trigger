trigger {{ object_name }}Trigger on {{ object_name }} (	before insert,	before update,	before delete,
												after insert,	after update,	after delete, after undelete) {
	
	if(Trigger.isInsert){
		if(Trigger.isBefore && {{ object_name }}Handler.runBeforeInsert){
			SObjectHandler.beforeInsert(Trigger.new);
		}

		if(Trigger.isAfter && {{ object_name }}Handler.runAfterInsert){
			SObjectHandler.afterInsert(Trigger.new);
		}
	}

	if(Trigger.isUpdate){
		if(Trigger.isBefore && {{ object_name }}Handler.runBeforeUpdate){
			SObjectHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
		}

		if(Trigger.isAfter && {{ object_name }}Handler.runAfterUpdate){
			SObjectHandler.afterUpdate(Trigger.new, Trigger.oldMap);
		}
	}

	if(Trigger.isDelete){
		if(Trigger.isBefore && {{ object_name }}Handler.runBeforeDelete){
			SObjectHandler.beforeDelete(Trigger.oldMap);
		}

		if(Trigger.isAfter && {{ object_name }}Handler.runAfterDelete){
			SObjectHandler.afterDelete(Trigger.oldMap);
		}
	}

	if(Trigger.isUndelete){
		if(Trigger.isAfter && {{ object_name }}Handler.runAfterUndelete){
			SObjectHandler.afterUndelete(Trigger.new);
		}
	}

}