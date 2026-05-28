import pymysql
from fastapi import FastAPI
import uvicorn
#anh em vào localhost//http://localhost:5000/docs mà xài nha
def get_connection():
    mydb = pymysql.connect(
        host="localhost",
        user="root",
        password="ahihidocho1652",
        database="beer",
        cursorclass=pymysql.cursors.DictCursor
    )
    return mydb

app = FastAPI(title="Beer Distribution System")

@app.get("/customers")
def get_customers():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM customers")
    customers = cursor.fetchall()
    conn.close()
    return customers

@app.get("/orders")
def get_orders():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM orders")
    orders = cursor.fetchall()
    conn.close()
    return orders

@app.get("/inventory")
def get_inventory():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM inventory")
    inventory = cursor.fetchall()
    conn.close()
    return inventory

@app.get("/products")
def get_products():
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()
    conn.close()
    return products

@app.post("/add-customer")
def add_customer(first_name: str, last_name: str, email: str, phone: str, address: str):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("AddNewCustomer", (first_name, last_name, email, phone, address))

        result = cursor.fetchall()

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "message": "Customer added successfully",
            "new_id": result[0]["new_customer_id"] if result else None
        }
    except Exception as e:
        return {"error": str(e)}

@app.post("/add-order")
def add_order(customer_id: str, payment_method: str, tax_amount: float, shipment_cost: float,
              payment_status: str, shipment_status: str, delivery_date: str):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("AddNewOrder", (
            customer_id, payment_method, tax_amount, shipment_cost,
            payment_status, shipment_status, delivery_date
        ))

        result = cursor.fetchall()

        conn.commit()
        cursor.close()
        conn.close()

        return {
            "message": "Order added successfully",
            "new_id": result[0]["new_order_id"] if result else None
        }
    except Exception as e:
        return {"error": str(e)}

@app.post("/add-order-detail")
def add_order_detail(order_id: str, prod_id: str, quantity: int):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("AddOrderDetail", (order_id, prod_id, quantity))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "message": f"Added product {prod_id} (x{quantity}) to order {order_id}"
        }
    except Exception as e:
        return {"error": str(e)}

@app.post("/process-exim")
def process_exim(prod_id: str, inv_id: str, type: str, exim_quantity: int):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("ProcessExIm", (prod_id, inv_id, type, exim_quantity))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "message": f"{type} processed successfully for product {prod_id}"
        }
    except Exception as e:
        return {"error": str(e)}

@app.get("/get-stock")
def get_stock(prod_id: str):
    try:
        conn = get_connection()
        cursor = conn.cursor()

        # Gọi hàm fn_get_stock(product_id)
        cursor.execute("SELECT fn_get_stock(%s) AS current_stock", (prod_id,))
        result = cursor.fetchone()

        cursor.close()
        conn.close()

        return {
            "product_id": prod_id,
            "current_stock": result["current_stock"] if result else None
        }
    except Exception as e:
        return {"error": str(e)}

@app.put("/update-order-status")
def update_order_status(order_id: str, payment_status: str, shipment_status: str):
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.callproc("UpdateOrderStatus", (order_id, payment_status, shipment_status))
        conn.commit()
        cursor.close()
        conn.close()

        return {
            "message": f"Order {order_id} updated successfully"
        }
    except Exception as e:
        return {"error": str(e)}



if __name__ == "__main__":
    uvicorn.run("business_test:app", host="localhost", port=5000, reload=True)
