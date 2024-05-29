require("dotenv").config();
const express = require("express");
const pool = require("./db");
const { Ollama } = require("ollama");
const ollama = new Ollama({ host: "http://localhost:11434" });

const app = express();
app.use(express.json());

const ollamacall = async (message) => {
  const result = await ollama.generate({
    model: "llama3",
    prompt: `
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
    
    give me query only and nothing else to get info of ${message} dont add extra text only send the code nothing extra only code no explanation needed dont give any \n or extra space in the code
      `,
  });
  console.log(result);
  return result;
};

app.get("/", async (req, res) => {
  try {
    const { message } = req.body;
    console.log(message);

    // const response = await pool.query("SELECT * FROM users");
    // console.log(response.rows);
    // res.json(response.rows);
    const result = await ollamacall(message);
    const response = await pool.query(result.response);
    // res.send(response);
    res.send(response.rows);
  } catch (error) {
    console.error(error.message);
    res.status(500).send("Internal Server Error");
  }
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
