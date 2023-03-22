import React from "react"

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

export default Task
