public virtual class EB_{{ object_name }}Dispatcher {
    
    public EB_{{ object_name }}Dispatcher(){

    }

    public override void beforeInsert(){
        //List<{{ object_name }}> nList = (List<{{ object_name }}>)newList;
        System.debug('Overriden');
    }

}