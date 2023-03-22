#!/bin/bash

# Take name from passed in arguement, or use default
front_name=${1:-frontend-task-manager}

npm install react-scripts
npx create-react-app $front_name --template typescript
cd $front_name

# Axios simplifies making HTTP requests from the browser
npm install axios

#Holds the types, made globally available with .d.ts
touch src/type.d.ts

echo "interface ITask {
  _id: string
  name: string
  description: string
  status: string
  createdAt?: string
  updatedAt?: string
}

interface TaskProps {
  task: ITask
}

type ApiDataType = {
  message: string
  status: string
  tasks: ITask[]
  task?: ITask
}" > src/type.d.ts

# Fetch data from the API
touch src/API.ts

echo 'import axios, { AxiosResponse } from "axios"

const baseUrl: string = "http://127.0.0.1:5000/test"

export const getTasks = async (): Promise<AxiosResponse<ApiDataType>> => {
  try {
    const tasks: AxiosResponse<ApiDataType> = await axios.get(
      baseUrl + "/tasks"
    )
    return tasks
  } catch (error) {
    throw new Error("Error! Cannot get tasks")
  }
}

export const addTask= async (
  formData: ITask
): Promise<AxiosResponse<ApiDataType>> => {
  try {
    const task: Omit<ITask, "_id"> = {
      name: formData.name,
      description: formData.description,
      status: "false",
    }
    const saveTask: AxiosResponse<ApiDataType> = await axios.post(
      baseUrl + "/add-task",
      task
    )
    return saveTask
  } catch (error) {
    throw new Error("Error! Cannot save tasks")
  }
}

export const updateTask = async (
  task: ITask
): Promise<AxiosResponse<ApiDataType>> => {
  try {
    const taskUpdate: Pick<ITask, "status"> = {
      status: "true",
    }
    const updatedTask: AxiosResponse<ApiDataType> = await axios.put(
      `${baseUrl}/edit-task/${task._id}`,
      taskUpdate
    )
    return updatedTask
  } catch (error) {
    throw new Error("Error! Cannot update tasks")
  }
}

export const deleteTask = async (
  _id: string
): Promise<AxiosResponse<ApiDataType>> => {
  try {
    const deletedTask: AxiosResponse<ApiDataType> = await axios.delete(
      `${baseUrl}/delete-task/${_id}`
    )
    return deletedTask
  } catch (error) {
    throw new Error("Error! Cannot delete tasks")
  }
}

' > src/API.ts

mkdir src/components
touch src/components/AddTask.tsx

# Create an add task form
#Uses a react Functional Component that recieves saveTask() method as
# a prop to save data to DB
echo '
import React, { useState } from "react"

type Props = { 
  saveTask: (e: React.FormEvent, formData: ITask | any) => void 
}

const AddTask: React.FC<Props> = ({ saveTask }) => {
  const [formData, setFormData] = useState<ITask | {}>()

  const handleForm = (e: React.FormEvent<HTMLInputElement>): void => {
    setFormData({
      ...formData,
      [e.currentTarget.id]: e.currentTarget.value,
    })
  }

  return (
    <form className="Form" onSubmit={(e) => saveTask(e, formData)}>
      <div>
        <div>
          <label htmlFor="name">Name</label>
          <input onChange={handleForm} type="text" id="name" />
        </div>
        <div>
          <label htmlFor="description">Description</label>
          <input onChange={handleForm} type="text" id="description" />
        </div>
      </div>
      <button disabled={formData === undefined ? true: false} >Add Task</button>
    </form>
  )
}

export default AddTask
' > src/components/AddTask.tsx

# Display a Task
touch src/components/TaskItem.tsx

echo 'import React from "react"

type Props = TaskProps & {
  updateTask: (task: ITask) => void
  deleteTask: (_id: string) => void
}

const Task: React.FC<Props> = ({ task, updateTask, deleteTask }) => {
  const checkTask: string = task.status ? `line-through` : ""
  return (
    <div className="Card">
      <div className="Card--text">
        <h1 className={checkTask}>{task.name}</h1>
        <span className={checkTask}>{task.description}</span>
      </div>
      <div className="Card--button">
        <button
          onClick={() => updateTask(task)}
          className={task.status ? `hide-button` : "Card--button__done"}
        >
          Complete
        </button>
        <button
          onClick={() => deleteTask(task._id)}
          className="Card--button__delete"
        >
          Delete
        </button>
      </div>
    </div>
  )
}

export default Task' > src/components/TaskItem.tsx

# Fetch and Display data
echo "
import React, { useEffect, useState } from 'react'
import TaskItem from './components/TaskItem'
import AddTask from './components/AddTask'
import { getTasks, addTask, updateTask, deleteTask } from './API'

const App: React.FC = () => {
  const [tasks, setTasks] = useState<ITask[]>([])

  useEffect(() => {
    fetchTasks()
  }, [])

  const fetchTasks = (): void => {
    getTasks()
    .then(({ data: { tasks } }: ITask[] | any) => setTasks(tasks))
    .catch((err: Error) => console.log(err))
  }

  const handleSaveTask = (e: React.FormEvent, formData: ITask): void => {
  e.preventDefault()
  addTask(formData)
    .then(({ status, data }) => {
      if (status !== 201) {
        throw new Error(\"Error! Task not saved\")
      }
      setTasks(data.tasks)
    })
    .catch(err => console.log(err))
}

const handleUpdateTask = (task: ITask): void => {
  updateTask(task)
    .then(({ status, data }) => {
      if (status !== 200) {
        throw new Error(\"Error! Task not updated\")
      }
      setTasks(data.tasks)
    })
    .catch(err => console.log(err))
}

const handleDeleteTask = (_id: string): void => {
  deleteTask(_id)
    .then(({ status, data }) => {
      if (status !== 200) {
        throw new Error(\"Error! Task not deleted\")
      }
      setTasks(data.tasks)
    })
    .catch(err => console.log(err))
}

  return (
    <main className='App'>
      <h1>My Tasks</h1>
      <AddTask saveTask={handleSaveTask} />
      {tasks.map((task: ITask) => (
        <TaskItem
          key={task._id}
          updateTask={handleUpdateTask}
          deleteTask={handleDeleteTask}
          task={task}
        />
      ))}
    </main>
  )
}

export default App
  
" > src/App.tsx

# Add styling
echo '
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #fff;
  background: #6c0e81;
}

.App {
  max-width: 728px;
  margin: 4rem auto;
}

.App > h1 {
  text-align: center;
  margin: 1rem 0;
}

.Card {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #218d6d;
  padding: 0.5rem 1rem;
  border-bottom: 1px solid #db721b;
}

.Card--text h1 {
  color: #ff9900;
}

.Card--button button {
  background: #f5f6f7;
  padding: 0.4rem 1rem;
  border-radius: 20px;
  cursor: pointer;
}

.Card--button__delete {
  border: 1px solid #ca0000;
  color: #ca0000;
}

.Card--button__done {
  border: 1px solid #00aa69;
  color: #00aa69;
  margin-right: 1rem;
}

.Form {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background: #444;
  margin-bottom: 1rem;
}

.Form > div {
  display: flex;
  justify-content: center;
  align-items: center;
}

.Form input {
  background: #f5f6f7;
  padding: 0.5rem 1rem;
  border: 1px solid #ff9900;
  border-radius: 10px;
  display: block;
  margin: 0.3rem 1rem 0 0;
}

.Form label {
}

.Form button {
  background: #ff9900;
  color: #fff;
  padding: 0.5rem 1rem;
  border-radius: 20px;
  cursor: pointer;
  border: none;
}

.line-through {
  text-decoration: line-through;
  color: #777 !important;
}

.hide-button {
  display: none;
}' > src/index.css

# Start client
# npm start
