require("dotenv").config();

const Groq = require("groq-sdk");
const groq = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

const express = require("express");

const pool = require("./db");

const app = express();
app.use(express.json());

const groqcall = async (message) => {
  const chatCompletion = await groq.chat.completions.create({
    messages: [
      {
        role: "user",
        content: `
        Here is my database schema:
        Users: (user_id, username, email, password, created_at)
        Products: (product_id, name, description, price, stock, created_at)
        Orders: (order_id, user_id, order_date, total)
        OrderItems: (order_item_id, order_id, product_id, quantity, price)
        Categories: (category_id, name, description)
        ProductCategories: (product_id, category_id)
        Reviews: (review_id, product_id, user_id, rating, comment, created_at)
        Addresses: (address_id, user_id, street, city, state, zip_code, country, created_at)
        Payments: (payment_id, order_id, payment_date, amount, payment_method)
      
      give me query only and nothing else to get info of ${message} dont add extra text only send the code nothing extra only code no explanation needed
        dont add any \n or extra space in the code or any stuff like  or anything else like that just code
      `,
      },
    ],
    model: "llama3-8b-8192",
    temperature: 1,
    max_tokens: 1024,
    top_p: 1,
    stream: false,
    stop: null,
  });

  console.log(chatCompletion.choices[0].message.content);
  return chatCompletion.choices[0].message.content;
};

app.get("/", async (req, res) => {
  try {
    const { message } = req.body;
    console.log(message);

    const result = await groqcall(message);
    const response = await pool.query(result);
    res.send(response.rows);
  } catch (error) {
    console.error(error.message);
    res.status(500).send("Internal Server Error");
  }
});

app.listen(4000, () => {
  console.log("Server is running on port 4000");
});
