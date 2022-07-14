import { LightningElement,track } from 'lwc';
import addTodo from "@salesforce/apex/ToDoController.addTodo";

export default class ToDoManager extends LightningElement {
    @track time = "1.16 PM";
    @track greeting = " Hello Motherfucker";

    @track todos =[];
    
    connectedCallback(){
        this.getTime();
    
        this.populateTodos();
    setInterval(() => {
       this.getTime();
       console.log("Set interval called");
    }, 1000);
}

    getTime(){
        const date= new Date();
        const hour = date.getHours();
        const min = date.getMinutes();
        this.time = `${this.getHour(hour)}:${this.getDoubleDigit(min)} ${this.getMidday(hour)}`;
        this.setgreeting(hour);
    }

    getHour(hour){
        return hour === 0 ? 12 : hour > 12 ? hour-12 : hour;
    }

    getMidday(hour){
        return hour >=12 ? "PM":"AM";
    }
        getDoubleDigit(digit){
            return digit <10 ? "0"+digit : digit;
    }
    setgreeting(hour){
        if(hour<12){
            this.greeting = "Good Morning Bitch";
        }
        else if(hour>=12 && hour <17){
            this.greeting = "Good Afternoon Bitch";
        }
        else {
            this.greeting = "Good Evening Bitch";
        }
    }

    addTodoHandler(){
        const inputbox = this.template.querySelector("lightning-input");

        //Js Object
        const todo = {
            todoId : this.todos.length,
            todoName : inputbox.value,
            done : false,
            todoDate : new Date()
        };
        this.todos.push(todo);
        inputbox.value = "";
    }
    get upcomingTasks(){
        return this.todos && this.todos.length ? this.todos.filter(todo  => !todo.done) : [];
    }

    get completedTasks(){
        return this.todos && this.todos.length ? this.todos.filter(todo  => todo.done) : [];
    }
    
    populateTodos(){
        const todo =[
        {
            todoId : 0,
            todoName : "Gand Marao",
            done : false,
            todoDate : new Date()   
        },
        {
            todoId : 1,
            todoName : "Bhujia Khao",
            done : false,
            todoDate : new Date()   
        },
        {
            todoId : 2,
            todoName : "Sut Jao",
            done : true,
            todoDate : new Date()   
        }

        ];
        this.todos = todo;    
    
    
    }

}