
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

