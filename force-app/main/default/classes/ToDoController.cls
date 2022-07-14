public with sharing class ToDoController {
    @AuraEnabled
    public static string addTodo(string payload){
        try {
            Todo payloadObject = (Todo)JSON.deserialize(payload,Todo.class);

            Sobject tsk = (Sobject)Type.forName('ToDo__c').newInstance();
            tsk.put('Name',payloadObject.todoName);
            tsk.put('Done__c',payloadObject.done);

            insert tsk;
            return string.valueOf(tsk.Id);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void  updateTodo(string payload){
        try {
            Todo payloadObject = (Todo)JSON.deserialize(payload,Todo.class);

            Sobject tsk = (Sobject)Type.forName('ToDo__c').newInstance();
            tsk.put('Id',payloadObject.todoId);
            tsk.put('Name',payloadObject.todoName);
            tsk.put('Done__c',payloadObject.done);

            update tsk;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteTodo(String todoId){
        try {
            
            Sobject tsk = (Sobject)Type.forName('ToDo__c').newInstance();
            tsk.put('Id',todoId);

            delete tsk;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Todo> getAllTodos(){
        try {
            List<Sobject> tsk = Database.query(
            'Select Id,Name, CreatedDate, Done__c from ToDo__c Where CreatedDate = LAST_N_DAYS:7 Order By CreatedDate DESC'
            );

            return getToDos(tsk);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Todo> getCurrentTodos(){
        try {
            List<Sobject> tsk = Database.query(
            'Select Id,Name, CreatedDate, Done__c from ToDo__c Where CreatedDate =TODAY Order By CreatedDate DESC'
            );

            return getToDos(tsk);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Todo> getToDos(List<Sobject> tsks){
        List<Todo> todos = new List<Todo>();
        for(Sobject tsk : tsks){
            Todo todo = new Todo();
            todo.todoId = tsk.Id;
            todo.todoName = String.valueOf(tsk.get('Name'));
            todo.todoDate = Date.valueOf(tsk.get('CreatedDate'));
            todo.done = Boolean.valueOf(tsk.get('Done__c'));
            todos.add(todo);
        }

        return todos;
    }
    class Todo{
        @AuraEnabled
        public string todoId;
        @AuraEnabled
        public string todoName;
        @AuraEnabled
        public Date todoDate;
        @AuraEnabled
        public Boolean done;

    }
}