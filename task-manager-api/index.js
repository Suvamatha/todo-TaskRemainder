const express = require('express')
const app = express();
const cors = require('cors');
const mongoose = require('mongoose');
const authRoutes = require('./auth');

require('dotenv').config();

app.use(cors());
app.use(express.json());
app.use('/auth', authRoutes);

mongoose.connect(process.env.MONGO_URI)
.then(() => console.log("MongoDb is connected"))
.catch((err) => console.log("DB Error: ", err))

app.get('/',(req,res)=>{
    res.send("Task manager is running..");
});

const taskSchema = new mongoose.Schema({
    title: String,
    done: {type: Boolean, default: false},
    priority: {
        type: String,
        enum: ['low', 'medium','high'],
        default: 'medium'
    },
});



const Task = mongoose.model('Task',taskSchema);

app.get('/tasks',async (req,res)=>{
    const tasks = await Task.find();
    res.json(tasks);
});
//for Post
app.post('/tasks', async (req,res)=>{
    const {title,priority} =req.body;

    if(!title){
        return res.status(400).json({message: "Title is required"});
    }
    const newTask = await Task.create({title, priority});
    res.status(201).json(newTask);
    
})

//for DELETE
app.delete('/tasks/:id', async(req,res)=>{
try{
    await Task.findByIdAndDelete(req.params.id);
    res.json({message: "Task deleted"});
}catch(err){
    res.status(500).json({message: "Server error", error: err.message});
}
});

app.patch('/tasks/:id', async (req,res)=>{
try{
    const task = await Task.findById(req.params.id);

    if(!task){
        return res.status(404).json({message: "Task not found"});
    }
    task.done = !task.done;
    await task.save();
    res.json(task);
}catch(err){
    res.status(500).json({message: "Server error", error: err.message});
}
});

app.listen(process.env.PORT,()=>{
    console.log(`Server is running in port ${process.env.PORT}`);
});


