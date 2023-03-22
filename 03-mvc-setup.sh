#!/bin/bash

backend_name=${1:-backend-task-manager}

cd $backend_name/
mkdir types
touch types/tasks.ts

echo "// Import Mongoose and its types
import { Document } from 'mongoose';

export interface ITask extends Document {
   name: string;
   description: string;
   status: string;
}" > types/tasks.ts

mkdir models 
touch models/tasks.ts

echo "import {ITask} from '../types/tasks';
import {model, Schema} from 'mongoose';

const taskSchema = new Schema ({
    name:{ type: String, required: true },
    description: { type: String, required: true },
    status: { type: Boolean, required: true }
    },
    {timestamps: true}
);

export default model('Task', taskSchema);" > models/tasks.ts

mkdir controllers
mkdir controllers/tasks
touch controllers/tasks/index.ts

echo "import {Response, Request} from 'express';
import {ITask} from '../../types/tasks';
import Task from '../../models/tasks';

//  Get all tasks
const getTasks = async(req: Request, res: Response): Promise<void> => {
 try {
    const tasks: ITask[] = await Task.find();
    res.status(200).json({tasks})
 } catch (error) {
    throw error
 }
}

// Add Task
const addTask = async(req: Request, res: Response): Promise<void> => {
    try {
    const body = req.body as Pick<ITask, 'name' | 'description' | 'status'>
    const task: ITask =  new  Task({
        name: body.name,
        description: body.description,
        status: body.status
    })
    const newTask: ITask =  await task.save()
    const allTask: ITask[] = await Task.find();
    res.status(201).json({message:'Task added', task: newTask, tasks: allTask});
    } catch (error) {
      res.status(500).json({message:'Error adding task', error})
    }
}

// Update Task
const updateTask =  async(req: Request, res: Response): Promise<void> => {
    try {
       const {
        params: {id},
        body,
       }  = req;
       const updateTask: ITask | null = await Task.findOneAndUpdate(
        {_id: id},
        body
       )
       const allTasks: ITask[] = await Task.find();
       res.status(200).json({message: 'Task updated', task: updateTask, tasks: allTasks })
    } catch (error) {
      throw error  
    }
}

// delete Task
const deleteTask  = async (req: Request, res: Response): Promise<void> => {
 try {
    const deletedTask: ITask | null = await Task.findByIdAndRemove(req.params.id);
    const allTasks = await Task.find();
    res.status(200).json({message: 'Task deleted', task: deletedTask, tasks: allTasks})
 } catch (error) {
    throw error
 }
}


export {getTasks, addTask, updateTask, deleteTask}" > controllers/tasks/index.ts

mkdir routes
touch routes/index.ts

echo "import { Router } from 'express';
import {getTasks, addTask, updateTask, deleteTask} from '../controllers/tasks';

const router : Router = Router();

router.get('/tasks',getTasks );
router.post('/tasks/add-task', addTask);
router.put('/edit-task/:id', updateTask);
router.delete('/delete-task/:id', deleteTask);

export default router;" > routes/index.ts