/* Create the database */
CREATE DATABASE IF NOT EXISTS ecommerce;

/* Switch to the ecommerce database */
USE ecommerce;

/* Drop existing tables in correct order to avoid foreign key constraints */
DROP TABLE IF EXISTS Ex_Im;
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS Product_Supplier;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Customers;
-- ==========================
-- Table: Customers
-- ==========================
CREATE TABLE Customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,
    address VARCHAR(255),
    loyalty_points INT DEFAULT 0 CHECK (loyalty_points >= 0),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- Table: Orders
-- ==========================
CREATE TABLE Orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    tax_amount DECIMAL(10,2) DEFAULT 0 CHECK (tax_amount >= 0),
    shipment_cost DECIMAL(10,2) DEFAULT 0 CHECK (shipment_cost >= 0),
    payment_method VARCHAR(50) CHECK (payment_method IN ('Bank Transfer','Credit Card','Cash')),
    payment_status VARCHAR(50) CHECK (payment_status IN ('Pending','Paid','Failed')),
    shipment_status VARCHAR(50) CHECK (shipment_status IN ('Pending','Confirmed','In Delivery','Delivered','Returned')),
    delivery_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- ==========================
-- Table: Products
-- ==========================
CREATE TABLE Products (
    prod_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- Table: Suppliers
-- ==========================
CREATE TABLE Suppliers (
    supplier_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15) UNIQUE
);

-- ==========================
-- Table: Inventory
-- ==========================
CREATE TABLE Inventory (
    inv_id VARCHAR(10) PRIMARY KEY,
    inv_address VARCHAR(255) NOT NULL,
    expiry_date DATE,
    current_quantity INT DEFAULT 0 CHECK (current_quantity >= 0),
    notes TEXT,
    last_audit_date DATE
);

-- ==========================
-- Table: Product_Supplier
-- ==========================
CREATE TABLE Product_Supplier (
    supplier_id VARCHAR(10),
    prod_id VARCHAR(10),
    contract_terms TEXT,
    supply_quantity INT CHECK (supply_quantity > 0),
    supply_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (supplier_id, prod_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES Products(prod_id) ON DELETE CASCADE
);

-- ==========================
-- Table: OrderDetail
-- ==========================
CREATE TABLE OrderDetail (
    order_id VARCHAR(10),
    prod_id VARCHAR(10),
    quantity INT NOT NULL CHECK (quantity > 0),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, prod_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES Products(prod_id) ON DELETE CASCADE
);

-- ==========================
-- Table: Ex_Im (Export/Import)
-- ==========================
CREATE TABLE Ex_Im (
    prod_id VARCHAR(10),
    inv_id VARCHAR(10),
    type ENUM('Export','Import') NOT NULL,
    ex_im_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    ex_im_quantity INT NOT NULL CHECK (ex_im_quantity > 0),
    PRIMARY KEY (prod_id, inv_id, ex_im_date),
    FOREIGN KEY (prod_id) REFERENCES Products(prod_id) ON DELETE CASCADE,
    FOREIGN KEY (inv_id) REFERENCES Inventory(inv_id) ON DELETE CASCADE
);


INSERT INTO Customers (customer_id, first_name, last_name, email, phone, address, loyalty_points)
VALUES
('CUS001','John','Smith','john.smith@gmail.com','+141555501','123 Main St, New York','25'),
('CUS002','Emma','Johnson','emma.johnson@gmail.com','+141555502','45 Market Rd, Chicago','30'),
('CUS003','Michael','Brown','michael.brown@gmail.com','+141555503','89 Elm St, Los Angeles','15'),
('CUS004','Olivia','Williams','olivia.williams@gmail.com','+141555504','17 Pine Ave, Houston','50'),
('CUS005','Liam','Jones','liam.jones@gmail.com','+141555505','78 Lake View, Dallas','20'),
('CUS006','Sophia','Garcia','sophia.garcia@gmail.com','+141555506','90 Cedar Dr, Miami','45'),
('CUS007','Noah','Martinez','noah.martinez@gmail.com','+141555507','31 King St, Seattle','35'),
('CUS008','Ava','Lopez','ava.lopez@gmail.com','+141555508','60 River Rd, Denver','40'),
('CUS009','Ethan','Gonzalez','ethan.gonzalez@gmail.com','+141555509','12 Forest Way, Boston','22'),
('CUS010','Isabella','Rodriguez','isabella.rodriguez@gmail.com','+141555510','14 Oak St, Austin','28'),
('CUS011','James','Wilson','james.wilson@gmail.com','+141555511','48 Grove St, Phoenix','36'),
('CUS012','Mia','Anderson','mia.anderson@gmail.com','+141555512','32 Sunset Blvd, Portland','18'),
('CUS013','Benjamin','Thomas','benjamin.thomas@gmail.com','+141555513','85 Queen St, San Diego','10'),
('CUS014','Charlotte','Taylor','charlotte.taylor@gmail.com','+141555514','53 King Ave, Atlanta','42'),
('CUS015','Alexander','Moore','alex.moore@gmail.com','+141555515','22 Birch Ln, Orlando','16'),
('CUS016','Amelia','Jackson','amelia.jackson@gmail.com','+141555516','27 Maple St, Detroit','50'),
('CUS017','Henry','White','henry.white@gmail.com','+141555517','70 Lincoln St, San Jose','37'),
('CUS018','Evelyn','Harris','evelyn.harris@gmail.com','+141555518','93 Park Ave, Tampa','45'),
('CUS019','Jacob','Clark','jacob.clark@gmail.com','+141555519','41 Harbor Rd, Charlotte','12'),
('CUS020','Harper','Lewis','harper.lewis@gmail.com','+141555520','28 High St, Nashville','39'),
('CUS021','Daniel','Walker','daniel.walker@gmail.com','+141555521','56 Ocean Dr, Indianapolis','22'),
('CUS022','Ella','Young','ella.young@gmail.com','+141555522','77 College Rd, Columbus','14'),
('CUS023','Matthew','Allen','matthew.allen@gmail.com','+141555523','19 Hill St, Minneapolis','27'),
('CUS024','Scarlett','King','scarlett.king@gmail.com','+141555524','68 Main Blvd, Kansas City','48'),
('CUS025','David','Scott','david.scott@gmail.com','+141555525','15 Sunset Rd, Baltimore','17'),
('CUS026','Victoria','Green','victoria.green@gmail.com','+141555526','34 Cypress Rd, Memphis','35'),
('CUS027','Joseph','Baker','joseph.baker@gmail.com','+141555527','26 Ridge St, Sacramento','12'),
('CUS028','Grace','Adams','grace.adams@gmail.com','+141555528','18 Pearl Rd, Louisville','40'),
('CUS029','Samuel','Nelson','samuel.nelson@gmail.com','+141555529','54 North St, Milwaukee','31'),
('CUS030','Chloe','Hill','chloe.hill@gmail.com','+141555530','62 East Ave, Cleveland','42'),
('CUS031','Andrew','Ramirez','andrew.ramirez@gmail.com','+141555531','81 Bay St, Tucson','20'),
('CUS032','Luna','Campbell','luna.campbell@gmail.com','+141555532','22 Vine St, Omaha','10'),
('CUS033','Elijah','Mitchell','elijah.mitchell@gmail.com','+141555533','73 Park Ln, Raleigh','19'),
('CUS034','Aria','Roberts','aria.roberts@gmail.com','+141555534','35 Maple Rd, Cincinnati','24'),
('CUS035','Logan','Carter','logan.carter@gmail.com','+141555535','44 Hillcrest, Miami','21'),
('CUS036','Layla','Phillips','layla.phillips@gmail.com','+141555536','92 Central Rd, Dallas','30'),
('CUS037','William','Evans','william.evans@gmail.com','+141555537','55 Broadway, Denver','13'),
('CUS038','Avery','Turner','avery.turner@gmail.com','+141555538','40 Long Rd, Seattle','25'),
('CUS039','Owen','Torres','owen.torres@gmail.com','+141555539','72 River View, Boston','22'),
('CUS040','Nora','Parker','nora.parker@gmail.com','+141555540','14 Park St, San Francisco','47'),
('CUS041','Luke','Collins','luke.collins@gmail.com','+141555541','85 Maple Ave, Austin','20'),
('CUS042','Hazel','Edwards','hazel.edwards@gmail.com','+141555542','24 Pine St, Chicago','37'),
('CUS043','Jack','Stewart','jack.stewart@gmail.com','+141555543','63 Lake Dr, Houston','29'),
('CUS044','Ella','Sanchez','ella.sanchez@gmail.com','+141555544','29 King St, Orlando','11'),
('CUS045','Sebastian','Morris','sebastian.morris@gmail.com','+141555545','75 Elm Dr, Detroit','26'),
('CUS046','Camila','Rogers','camila.rogers@gmail.com','+141555546','90 Forest Dr, Phoenix','32'),
('CUS047','Mason','Reed','mason.reed@gmail.com','+141555547','16 Ocean St, Atlanta','40'),
('CUS048','Lily','Cook','lily.cook@gmail.com','+141555548','38 Lincoln Rd, Denver','23'),
('CUS049','Ethan','Morgan','ethan.morgan@gmail.com','+141555549','47 College Rd, New York','38'),
('CUS050','Zoe','Bell','zoe.bell@gmail.com','+141555550','80 Queen St, Los Angeles','45');

INSERT INTO Orders 
(order_id, customer_id, total_amount, tax_amount, shipment_cost, payment_method, payment_status, shipment_status, delivery_date)
VALUES
('ORD001','CUS001',450.00,45.00,25.00,'Credit Card','Paid','Delivered','2025-07-01'),
('ORD002','CUS002',320.00,32.00,18.00,'Cash','Pending','Pending','2025-07-02'),
('ORD003','CUS003',275.00,27.50,20.00,'Bank Transfer','Paid','Delivered','2025-07-03'),
('ORD004','CUS004',360.00,36.00,15.00,'Credit Card','Paid','Delivered','2025-07-04'),
('ORD005','CUS005',190.00,19.00,10.00,'Cash','Failed','Pending','2025-07-05'),
('ORD006','CUS006',420.00,42.00,20.00,'Credit Card','Paid','Delivered','2025-07-06'),
('ORD007','CUS007',310.00,31.00,18.00,'Cash','Pending','In Delivery','2025-07-07'),
('ORD008','CUS008',280.00,28.00,15.00,'Bank Transfer','Paid','Delivered','2025-07-08'),
('ORD009','CUS009',400.00,40.00,25.00,'Credit Card','Paid','Delivered','2025-07-09'),
('ORD010','CUS010',390.00,39.00,22.00,'Cash','Pending','Pending','2025-07-10'),
('ORD011','CUS011',250.00,25.00,12.00,'Credit Card','Paid','Delivered','2025-07-11'),
('ORD012','CUS012',480.00,48.00,30.00,'Bank Transfer','Paid','Delivered','2025-07-12'),
('ORD013','CUS013',150.00,15.00,10.00,'Cash','Pending','Pending','2025-07-13'),
('ORD014','CUS014',320.00,32.00,20.00,'Credit Card','Paid','Delivered','2025-07-14'),
('ORD015','CUS015',410.00,41.00,25.00,'Cash','Paid','Delivered','2025-07-15'),
('ORD016','CUS016',190.00,19.00,15.00,'Bank Transfer','Paid','Delivered','2025-07-16'),
('ORD017','CUS017',220.00,22.00,10.00,'Credit Card','Pending','In Delivery','2025-07-17'),
('ORD018','CUS018',360.00,36.00,20.00,'Cash','Paid','Delivered','2025-07-18'),
('ORD019','CUS019',400.00,40.00,25.00,'Bank Transfer','Paid','Delivered','2025-07-19'),
('ORD020','CUS020',280.00,28.00,15.00,'Credit Card','Pending','Pending','2025-07-20'),
('ORD021','CUS021',500.00,50.00,30.00,'Credit Card','Paid','Delivered','2025-07-21'),
('ORD022','CUS022',260.00,26.00,15.00,'Cash','Paid','Delivered','2025-07-22'),
('ORD023','CUS023',340.00,34.00,18.00,'Bank Transfer','Pending','In Delivery','2025-07-23'),
('ORD024','CUS024',200.00,20.00,12.00,'Credit Card','Paid','Delivered','2025-07-24'),
('ORD025','CUS025',390.00,39.00,22.00,'Cash','Paid','Delivered','2025-07-25'),
('ORD026','CUS026',420.00,42.00,20.00,'Credit Card','Pending','In Delivery','2025-07-26'),
('ORD027','CUS027',310.00,31.00,15.00,'Bank Transfer','Paid','Delivered','2025-07-27'),
('ORD028','CUS028',270.00,27.00,18.00,'Cash','Pending','Pending','2025-07-28'),
('ORD029','CUS029',350.00,35.00,25.00,'Credit Card','Paid','Delivered','2025-07-29'),
('ORD030','CUS030',260.00,26.00,12.00,'Bank Transfer','Paid','Delivered','2025-07-30'),
('ORD031','CUS031',180.00,18.00,10.00,'Cash','Pending','Pending','2025-07-31'),
('ORD032','CUS032',400.00,40.00,20.00,'Credit Card','Paid','Delivered','2025-08-01'),
('ORD033','CUS033',450.00,45.00,25.00,'Bank Transfer','Paid','Delivered','2025-08-02'),
('ORD034','CUS034',220.00,22.00,10.00,'Cash','Pending','Pending','2025-08-03'),
('ORD035','CUS035',370.00,37.00,18.00,'Credit Card','Paid','Delivered','2025-08-04'),
('ORD036','CUS036',310.00,31.00,15.00,'Cash','Pending','In Delivery','2025-08-05'),
('ORD037','CUS037',490.00,49.00,28.00,'Credit Card','Paid','Delivered','2025-08-06'),
('ORD038','CUS038',330.00,33.00,16.00,'Cash','Paid','Delivered','2025-08-07'),
('ORD039','CUS039',290.00,29.00,15.00,'Bank Transfer','Pending','In Delivery','2025-08-08'),
('ORD040','CUS040',260.00,26.00,10.00,'Credit Card','Paid','Delivered','2025-08-09'),
('ORD041','CUS041',380.00,38.00,22.00,'Cash','Paid','Delivered','2025-08-10'),
('ORD042','CUS042',410.00,41.00,25.00,'Bank Transfer','Pending','Pending','2025-08-11'),
('ORD043','CUS043',300.00,30.00,14.00,'Credit Card','Paid','Delivered','2025-08-12'),
('ORD044','CUS044',250.00,25.00,10.00,'Cash','Pending','Pending','2025-08-13'),
('ORD045','CUS045',290.00,29.00,12.00,'Credit Card','Paid','Delivered','2025-08-14'),
('ORD046','CUS046',350.00,35.00,15.00,'Cash','Paid','Delivered','2025-08-15'),
('ORD047','CUS047',280.00,28.00,15.00,'Credit Card','Pending','Pending','2025-08-16'),
('ORD048','CUS048',370.00,37.00,18.00,'Bank Transfer','Paid','Delivered','2025-08-17'),
('ORD049','CUS049',330.00,33.00,20.00,'Credit Card','Pending','In Delivery','2025-08-18'),
('ORD050','CUS050',460.00,46.00,25.00,'Cash','Paid','Delivered','2025-08-19');

INSERT INTO Products (prod_id, name, category, price)
VALUES
('PRD001','Heineken Original Lager 330ml','Lager',2.50),
('PRD002','Budweiser King of Beers 355ml','Lager',2.40),
('PRD003','Corona Extra 355ml','Pale Lager',2.80),
('PRD004','Guinness Draught 440ml','Stout',3.50),
('PRD005','Carlsberg Danish Pilsner 330ml','Pilsner',2.30),
('PRD006','Stella Artois Premium Lager 330ml','Lager',2.60),
('PRD007','Hoegaarden Belgian White 330ml','Wheat Beer',3.00),
('PRD008','Asahi Super Dry 330ml','Dry Lager',2.70),
('PRD009','Tiger Beer 330ml','Lager',2.40),
('PRD010','Beck’s Original German Lager 330ml','Lager',2.30),
('PRD011','Kronenbourg 1664 Blanc 330ml','Wheat Beer',3.10),
('PRD012','Tsingtao Chinese Lager 330ml','Lager',2.20),
('PRD013','Peroni Nastro Azzurro 330ml','Italian Lager',2.90),
('PRD014','Sapporo Premium Beer 355ml','Japanese Lager',2.80),
('PRD015','San Miguel Pale Pilsen 330ml','Pale Lager',2.10),
('PRD016','Bud Light 355ml','Light Lager',2.00),
('PRD017','Coors Light 355ml','Light Lager',2.10),
('PRD018','Miller Genuine Draft 355ml','Lager',2.30),
('PRD019','Michelob Ultra 355ml','Low Carb Lager',2.40),
('PRD020','Becks Blue Non-Alcoholic 330ml','Non-Alcoholic',2.20),
('PRD021','Bintang Pilsener 330ml','Pilsner',2.50),
('PRD022','Singha Thai Lager 330ml','Lager',2.60),
('PRD023','Chang Classic 330ml','Lager',2.30),
('PRD024','Leffe Blonde Abbey Beer 330ml','Blonde Ale',3.20),
('PRD025','Leffe Brune Abbey Beer 330ml','Dark Ale',3.30),
('PRD026','Erdinger Weissbier 500ml','Wheat Beer',3.60),
('PRD027','Weihenstephaner Hefeweissbier 500ml','Wheat Beer',3.80),
('PRD028','Paulaner Weissbier 500ml','Wheat Beer',3.70),
('PRD029','Hoegaarden Rosée 330ml','Fruit Beer',3.00),
('PRD030','Budweiser Zero 355ml','Non-Alcoholic',2.10),
('PRD031','Carib Lager 330ml','Lager',2.20),
('PRD032','Red Stripe Jamaican Lager 355ml','Lager',2.40),
('PRD033','Dos Equis XX Lager Especial 355ml','Mexican Lager',2.50),
('PRD034','Modelo Especial 355ml','Pale Lager',2.70),
('PRD035','Pacifico Clara 355ml','Mexican Lager',2.60),
('PRD036','Blue Moon Belgian White 355ml','Wheat Beer',3.10),
('PRD037','Goose Island IPA 355ml','IPA',3.40),
('PRD038','Lagunitas IPA 355ml','IPA',3.30),
('PRD039','Sierra Nevada Pale Ale 355ml','Pale Ale',3.20),
('PRD040','Samuel Adams Boston Lager 355ml','Lager',3.00),
('PRD041','Brooklyn Lager 355ml','Amber Lager',3.10),
('PRD042','Anchor Steam Beer 355ml','California Common',3.50),
('PRD043','Deschutes Black Butte Porter 355ml','Porter',3.60),
('PRD044','Newcastle Brown Ale 355ml','Brown Ale',3.00),
('PRD045','Guinness Foreign Extra Stout 330ml','Stout',3.80),
('PRD046','Hoegaarden 0.0% 330ml','Non-Alcoholic',2.50),
('PRD047','BrewDog Punk IPA 355ml','IPA',3.40),
('PRD048','Budweiser Nitro Reserve Gold 355ml','Golden Lager',3.20),
('PRD049','Heineken Silver 330ml','Light Lager',2.60),
('PRD050','Tiger Crystal 330ml','Pale Lager',2.40);

INSERT INTO Suppliers (supplier_id, name, address, phone)
VALUES
('SUP001','Heineken International','Amsterdam, Netherlands','+31205123000'),
('SUP002','Anheuser-Busch InBev','St. Louis, Missouri, USA','+13145550001'),
('SUP003','Carlsberg Group','Copenhagen, Denmark','+4533203000'),
('SUP004','Molson Coors Beverage Company','Chicago, Illinois, USA','+13125550002'),
('SUP005','Asahi Breweries Ltd','Tokyo, Japan','+81312345670'),
('SUP006','Kirin Brewery Company','Tokyo, Japan','+81398765432'),
('SUP007','Sapporo Breweries Ltd','Tokyo, Japan','+81333331234'),
('SUP008','Guinness Brewery (Diageo)','Dublin, Ireland','+35314000000'),
('SUP009','Tsingtao Brewery','Qingdao, China','+8653280000001'),
('SUP010','Snow Beer (China Resources)','Beijing, China','+861020000001'),
('SUP011','Budweiser Brewing Co. APAC','Hong Kong, China','+85221234567'),
('SUP012','Tiger Brewery (Asia Pacific Breweries)','Singapore','+6563331122'),
('SUP013','San Miguel Brewery','Manila, Philippines','+63288888888'),
('SUP014','Singha Corporation','Bangkok, Thailand','+6622428000'),
('SUP015','Chang Beer (ThaiBev)','Bangkok, Thailand','+6622025000'),
('SUP016','Peroni Brewery (Asahi Europe)','Rome, Italy','+39061234567'),
('SUP017','Birra Moretti','Milan, Italy','+390255501234'),
('SUP018','Kronenbourg Brewery','Strasbourg, France','+33388111111'),
('SUP019','Hoegaarden Brewery','Hoegaarden, Belgium','+3211445000'),
('SUP020','Leffe Abbey Brewery','Dinant, Belgium','+3282212222'),
('SUP021','Erdinger Weissbräu','Erding, Germany','+4981224091'),
('SUP022','Paulaner Brewery','Munich, Germany','+4989312110'),
('SUP023','Weihenstephan Brewery','Freising, Germany','+4981615310'),
('SUP024','Beck’s Brewery','Bremen, Germany','+4942116901'),
('SUP025','Bitburger Brewery','Bitburg, Germany','+4965619500'),
('SUP026','Modelo Brewery','Mexico City, Mexico','+525555555555'),
('SUP027','Corona Brewery (Grupo Modelo)','Mexico City, Mexico','+525555777777'),
('SUP028','Pacifico Brewery','Mazatlán, Mexico','+526692333333'),
('SUP029','Dos Equis Brewery (Heineken Mexico)','Monterrey, Mexico','+528181234567'),
('SUP030','Carib Brewery','Port of Spain, Trinidad','+18686233444'),
('SUP031','Red Stripe Brewery','Kingston, Jamaica','+18769223344'),
('SUP032','Brooklyn Brewery','Brooklyn, New York, USA','+17187651111'),
('SUP033','Sierra Nevada Brewing Co.','Chico, California, USA','+15308920000'),
('SUP034','Lagunitas Brewing Company','Petaluma, California, USA','+17077691234'),
('SUP035','Goose Island Beer Co.','Chicago, Illinois, USA','+13124550000'),
('SUP036','Blue Moon Brewing Company','Denver, Colorado, USA','+13035551111'),
('SUP037','Anchor Brewing Company','San Francisco, California, USA','+14155552000'),
('SUP038','Samuel Adams Brewery (Boston Beer Co.)','Boston, Massachusetts, USA','+16175553333'),
('SUP039','Deschutes Brewery','Bend, Oregon, USA','+15413823555'),
('SUP040','Newcastle Brewery','Newcastle upon Tyne, UK','+441912223333'),
('SUP041','BrewDog Brewery','Ellon, Scotland','+441355555555'),
('SUP042','Beavertown Brewery','London, UK','+442071234567'),
('SUP043','Fuller’s Brewery','London, UK','+442087482222'),
('SUP044','Guinness Open Gate Brewery','Baltimore, Maryland, USA','+14105557777'),
('SUP045','Michelob Brewery','St. Louis, Missouri, USA','+13145550100'),
('SUP046','Coors Brewery','Golden, Colorado, USA','+13035551234'),
('SUP047','Miller Brewery','Milwaukee, Wisconsin, USA','+14145556789'),
('SUP048','Bintang Brewery','Jakarta, Indonesia','+62217444444'),
('SUP049','Chang Distribution Center','Chiang Mai, Thailand','+6653123456'),
('SUP050','Heineken Asia Pacific','Singapore','+6566881122');

INSERT INTO Inventory (inv_id, inv_address, expiry_date, current_quantity, notes, last_audit_date)
VALUES
('INV001','Warehouse A - New York, USA','2025-12-30',3500,'Main East Coast storage','2025-07-01'),
('INV002','Warehouse B - Los Angeles, USA','2025-11-15',4200,'West Coast storage','2025-07-02'),
('INV003','Warehouse C - Chicago, USA','2026-01-20',2800,'Central region supply hub','2025-07-03'),
('INV004','Warehouse D - Houston, USA','2025-10-10',3100,'South US warehouse','2025-07-04'),
('INV005','Warehouse E - Miami, USA','2025-12-05',2500,'Southern coastal depot','2025-07-05'),
('INV006','Warehouse F - Seattle, USA','2026-02-14',3900,'Pacific Northwest distribution','2025-07-06'),
('INV007','Warehouse G - Denver, USA','2025-11-22',3300,'Rocky Mountain center','2025-07-07'),
('INV008','Warehouse H - Boston, USA','2026-03-10',2600,'Northeast supply','2025-07-08'),
('INV009','Warehouse I - Dallas, USA','2025-09-15',3700,'Southwest beer depot','2025-07-09'),
('INV010','Warehouse J - San Francisco, USA','2025-12-01',4100,'Bay Area hub','2025-07-10'),
('INV011','Warehouse K - Toronto, Canada','2026-01-05',2800,'Canadian distribution point','2025-07-11'),
('INV012','Warehouse L - Vancouver, Canada','2026-03-18',2900,'West Canada storage','2025-07-12'),
('INV013','Warehouse M - Mexico City, Mexico','2026-02-10',4500,'Main Mexico distributor','2025-07-13'),
('INV014','Warehouse N - Guadalajara, Mexico','2025-11-22',3100,'Western Mexico storage','2025-07-14'),
('INV015','Warehouse O - Monterrey, Mexico','2025-10-30',3600,'Northern Mexico hub','2025-07-15'),
('INV016','Warehouse P - London, UK','2025-12-28',4000,'Main UK warehouse','2025-07-16'),
('INV017','Warehouse Q - Manchester, UK','2026-01-30',3200,'Northern UK distribution','2025-07-17'),
('INV018','Warehouse R - Glasgow, Scotland','2026-02-12',2700,'Scottish regional center','2025-07-18'),
('INV019','Warehouse S - Dublin, Ireland','2026-03-05',4100,'Irish beer distribution','2025-07-19'),
('INV020','Warehouse T - Paris, France','2026-01-14',3800,'Central Europe hub','2025-07-20'),
('INV021','Warehouse U - Berlin, Germany','2026-02-22',4000,'German central warehouse','2025-07-21'),
('INV022','Warehouse V - Munich, Germany','2026-03-01',4300,'Bavarian storage facility','2025-07-22'),
('INV023','Warehouse W - Brussels, Belgium','2025-12-10',3500,'Benelux region hub','2025-07-23'),
('INV024','Warehouse X - Amsterdam, Netherlands','2026-03-25',3700,'Northern Europe logistics','2025-07-24'),
('INV025','Warehouse Y - Copenhagen, Denmark','2026-04-02',3100,'Nordic regional center','2025-07-25'),
('INV026','Warehouse Z - Oslo, Norway','2026-03-12',2600,'Scandinavian supply hub','2025-07-26'),
('INV027','Warehouse AA - Stockholm, Sweden','2026-04-18',2800,'Northern European stock','2025-07-27'),
('INV028','Warehouse AB - Warsaw, Poland','2026-02-08',3900,'Eastern Europe center','2025-07-28'),
('INV029','Warehouse AC - Prague, Czech Republic','2026-03-16',4200,'Central Europe supply','2025-07-29'),
('INV030','Warehouse AD - Rome, Italy','2026-01-25',3600,'Southern Europe hub','2025-07-30'),
('INV031','Warehouse AE - Madrid, Spain','2026-03-10',3300,'Iberian peninsula center','2025-07-31'),
('INV032','Warehouse AF - Lisbon, Portugal','2026-02-20',2700,'Western Europe warehouse','2025-08-01'),
('INV033','Warehouse AG - Singapore','2026-04-30',4000,'Southeast Asia hub','2025-08-02'),
('INV034','Warehouse AH - Bangkok, Thailand','2026-01-08',3700,'Thailand central depot','2025-08-03'),
('INV035','Warehouse AI - Jakarta, Indonesia','2026-02-14',3400,'Indonesian distribution','2025-08-04'),
('INV036','Warehouse AJ - Manila, Philippines','2026-03-11',3500,'Philippine storage','2025-08-05'),
('INV037','Warehouse AK - Kuala Lumpur, Malaysia','2026-04-06',3600,'Malaysia logistics center','2025-08-06'),
('INV038','Warehouse AL - Seoul, South Korea','2026-05-02',4100,'Korean supply hub','2025-08-07'),
('INV039','Warehouse AM - Beijing, China','2026-03-18',4300,'Northern China warehouse','2025-08-08'),
('INV040','Warehouse AN - Shanghai, China','2026-04-01',4200,'Eastern China center','2025-08-09'),
('INV041','Warehouse AO - Hong Kong, China','2026-03-22',3800,'Hong Kong logistics hub','2025-08-10'),
('INV042','Warehouse AP - Hanoi, Vietnam','2026-05-10',3900,'Vietnam main storage','2025-08-11'),
('INV043','Warehouse AQ - Ho Chi Minh City, Vietnam','2026-04-28',4100,'Southern Vietnam depot','2025-08-12'),
('INV044','Warehouse AR - Sydney, Australia','2026-02-05',3700,'Australia east coast hub','2025-08-13'),
('INV045','Warehouse AS - Melbourne, Australia','2026-03-30',3400,'Australia southern hub','2025-08-14'),
('INV046','Warehouse AT - Auckland, New Zealand','2026-04-15',2800,'New Zealand distribution','2025-08-15'),
('INV047','Warehouse AU - Cape Town, South Africa','2026-05-25',3100,'Africa southern depot','2025-08-16'),
('INV048','Warehouse AV - Nairobi, Kenya','2026-04-11',3500,'East Africa storage','2025-08-17'),
('INV049','Warehouse AW - Lagos, Nigeria','2026-03-20',4000,'West Africa supply center','2025-08-18'),
('INV050','Warehouse AX - Dubai, UAE','2026-04-24',4200,'Middle East logistics hub','2025-08-19');

INSERT INTO Product_Supplier (supplier_id, prod_id, contract_terms, supply_quantity, supply_date)
VALUES
('SUP001','PRD001','Annual distribution agreement covering Heineken Original across North America',5000,'2025-07-01'),
('SUP002','PRD002','Exclusive Budweiser supply for eastern states',4500,'2025-07-01'),
('SUP002','PRD016','Light beer distribution contract for Bud Light brand',4800,'2025-07-02'),
('SUP003','PRD005','Carlsberg supply partnership for premium pilsners',4200,'2025-07-02'),
('SUP004','PRD017','Coors Light distribution under Molson Coors network',4600,'2025-07-03'),
('SUP004','PRD018','Miller Genuine Draft delivery contract, Midwest region',4700,'2025-07-03'),
('SUP005','PRD008','Exclusive Asahi Super Dry import rights for US and EU',4000,'2025-07-04'),
('SUP006','PRD006','Kirin joint production for Stella Artois line in Asia',3900,'2025-07-05'),
('SUP007','PRD014','Sapporo Premium distribution for Japan and Pacific',4100,'2025-07-06'),
('SUP008','PRD004','Guinness Draught global supply and packaging agreement',5200,'2025-07-07'),
('SUP008','PRD045','Guinness Foreign Extra Stout export contract',5100,'2025-07-07'),
('SUP009','PRD012','Tsingtao Lager China–ASEAN export agreement',4800,'2025-07-08'),
('SUP010','PRD027','Snow Beer distribution for northern Chinese markets',4400,'2025-07-09'),
('SUP011','PRD048','Budweiser Nitro Gold exclusive canning partnership',4000,'2025-07-10'),
('SUP012','PRD009','Tiger Beer contract for Singapore and Malaysia',4600,'2025-07-11'),
('SUP013','PRD015','San Miguel Pale Pilsen supply for Southeast Asia',4700,'2025-07-12'),
('SUP014','PRD022','Singha Beer Thai export contract to Europe',4500,'2025-07-13'),
('SUP015','PRD023','Chang Classic beer local supply across Asia',4300,'2025-07-14'),
('SUP016','PRD013','Peroni Italian Lager distribution to Europe',4200,'2025-07-15'),
('SUP017','PRD025','Birra Moretti and Leffe Brune dual brand contract',3900,'2025-07-16'),
('SUP018','PRD011','Kronenbourg Blanc licensed for French and EU markets',4100,'2025-07-17'),
('SUP019','PRD007','Hoegaarden Belgian White import partnership',4600,'2025-07-18'),
('SUP019','PRD029','Hoegaarden Rosée fruit beer distribution',3800,'2025-07-19'),
('SUP020','PRD024','Leffe Blonde supply contract with long-term renewal',4200,'2025-07-20'),
('SUP021','PRD026','Erdinger Weissbier export to Asian distributors',4700,'2025-07-21'),
('SUP022','PRD028','Paulaner Wheat Beer contract with logistics support',4800,'2025-07-22'),
('SUP023','PRD027','Weihenstephaner Hefeweissbier license for EU markets',4500,'2025-07-23'),
('SUP024','PRD010','Beck’s German Lager exclusive US distribution',4300,'2025-07-24'),
('SUP025','PRD031','Bitburger and Carib Lager dual logistics contract',3900,'2025-07-25'),
('SUP026','PRD034','Modelo Especial premium beer delivery',4700,'2025-07-26'),
('SUP027','PRD003','Corona Extra distribution across Latin America',5100,'2025-07-27'),
('SUP028','PRD035','Pacifico Clara distribution to coastal states',4400,'2025-07-28'),
('SUP029','PRD033','Dos Equis Mexican Lager supply contract',4200,'2025-07-29'),
('SUP030','PRD032','Carib Lager Caribbean export logistics',4100,'2025-07-30'),
('SUP031','PRD032','Red Stripe regional partnership in Jamaica',4200,'2025-07-31'),
('SUP032','PRD041','Brooklyn Lager domestic US supply chain',4000,'2025-08-01'),
('SUP033','PRD039','Sierra Nevada Pale Ale export contract',3900,'2025-08-02'),
('SUP034','PRD038','Lagunitas IPA distribution for California and West Coast',4300,'2025-08-03'),
('SUP035','PRD037','Goose Island IPA US–EU trade route agreement',4100,'2025-08-04'),
('SUP036','PRD036','Blue Moon Belgian White retail distribution',4600,'2025-08-05'),
('SUP037','PRD042','Anchor Steam Beer historic supply partnership',3700,'2025-08-06'),
('SUP038','PRD040','Samuel Adams Boston Lager craft beer distribution',3900,'2025-08-07'),
('SUP039','PRD043','Deschutes Porter Western US supply line',4000,'2025-08-08'),
('SUP040','PRD044','Newcastle Brown Ale European contract',4100,'2025-08-09'),
('SUP041','PRD047','BrewDog Punk IPA UK & EU distribution',4200,'2025-08-10'),
('SUP042','PRD046','Hoegaarden 0.0% UK craft partnership',3600,'2025-08-11'),
('SUP043','PRD049','Heineken Silver global expansion contract',4800,'2025-08-12'),
('SUP044','PRD045','Guinness export for North American market',4500,'2025-08-13'),
('SUP048','PRD021','Bintang Pilsener Indonesia supply deal',4600,'2025-08-14'),
('SUP049','PRD023','Chang Distribution cross-border logistics',4300,'2025-08-15'),
('SUP050','PRD050','Tiger Crystal Asia Pacific regional partnership',4700,'2025-08-16');

INSERT INTO OrderDetail (order_id, prod_id, quantity, order_date)
VALUES
('ORD001','PRD001',24,'2025-07-01'),
('ORD002','PRD003',12,'2025-07-02'),
('ORD002','PRD005',6,'2025-07-02'),
('ORD003','PRD004',18,'2025-07-03'),
('ORD004','PRD006',20,'2025-07-04'),
('ORD005','PRD007',15,'2025-07-05'),
('ORD006','PRD008',24,'2025-07-06'),
('ORD007','PRD009',30,'2025-07-07'),
('ORD008','PRD010',12,'2025-07-08'),
('ORD009','PRD011',18,'2025-07-09'),
('ORD010','PRD012',20,'2025-07-10'),
('ORD011','PRD013',25,'2025-07-11'),
('ORD012','PRD014',15,'2025-07-12'),
('ORD013','PRD015',24,'2025-07-13'),
('ORD014','PRD016',30,'2025-07-14'),
('ORD015','PRD017',18,'2025-07-15'),
('ORD016','PRD018',24,'2025-07-16'),
('ORD017','PRD019',20,'2025-07-17'),
('ORD018','PRD020',15,'2025-07-18'),
('ORD019','PRD021',12,'2025-07-19'),
('ORD020','PRD022',24,'2025-07-20'),
('ORD021','PRD023',30,'2025-07-21'),
('ORD022','PRD024',15,'2025-07-22'),
('ORD023','PRD025',18,'2025-07-23'),
('ORD024','PRD026',24,'2025-07-24'),
('ORD025','PRD027',20,'2025-07-25'),
('ORD026','PRD028',15,'2025-07-26'),
('ORD027','PRD029',12,'2025-07-27'),
('ORD028','PRD030',18,'2025-07-28'),
('ORD029','PRD031',24,'2025-07-29'),
('ORD030','PRD032',30,'2025-07-30'),
('ORD031','PRD033',15,'2025-07-31'),
('ORD032','PRD034',20,'2025-08-01'),
('ORD033','PRD035',12,'2025-08-02'),
('ORD034','PRD036',24,'2025-08-03'),
('ORD035','PRD037',30,'2025-08-04'),
('ORD036','PRD038',18,'2025-08-05'),
('ORD037','PRD039',15,'2025-08-06'),
('ORD038','PRD040',20,'2025-08-07'),
('ORD039','PRD041',24,'2025-08-08'),
('ORD040','PRD042',12,'2025-08-09'),
('ORD041','PRD043',15,'2025-08-10'),
('ORD042','PRD044',18,'2025-08-11'),
('ORD043','PRD045',20,'2025-08-12'),
('ORD044','PRD046',30,'2025-08-13'),
('ORD045','PRD047',24,'2025-08-14'),
('ORD046','PRD048',12,'2025-08-15'),
('ORD047','PRD049',15,'2025-08-16'),
('ORD048','PRD050',18,'2025-08-17'),
('ORD049','PRD001',20,'2025-08-18'),
('ORD050','PRD002',25,'2025-08-19');

INSERT INTO Ex_Im (prod_id, inv_id, type, ex_im_date, ex_im_quantity)
VALUES
('PRD001','INV001','Import','2025-07-01 08:30:00',1200),
('PRD002','INV001','Import','2025-07-01 10:00:00',950),
('PRD003','INV001','Export','2025-07-02 14:15:00',500),
('PRD004','INV002','Import','2025-07-02 09:20:00',1300),
('PRD005','INV002','Export','2025-07-03 15:45:00',600),
('PRD006','INV003','Import','2025-07-03 08:00:00',1500),
('PRD007','INV003','Export','2025-07-04 12:10:00',700),
('PRD008','INV004','Import','2025-07-04 09:00:00',1100),
('PRD009','INV004','Export','2025-07-05 13:00:00',400),
('PRD010','INV005','Import','2025-07-05 07:30:00',1000),
('PRD011','INV005','Export','2025-07-06 14:00:00',450),
('PRD012','INV001','Import','2025-07-06 09:40:00',1250),
('PRD013','INV001','Export','2025-07-07 15:10:00',600),
('PRD014','INV002','Import','2025-07-07 08:20:00',1300),
('PRD015','INV002','Export','2025-07-08 11:00:00',550),
('PRD016','INV003','Import','2025-07-08 10:00:00',1400),
('PRD017','INV003','Export','2025-07-09 16:20:00',650),
('PRD018','INV004','Import','2025-07-09 08:00:00',1500),
('PRD019','INV004','Export','2025-07-10 13:00:00',700),
('PRD020','INV005','Import','2025-07-10 09:30:00',1250),
('PRD021','INV005','Export','2025-07-11 15:45:00',500),
('PRD022','INV001','Import','2025-07-11 08:15:00',1350),
('PRD023','INV001','Export','2025-07-12 17:00:00',750),
('PRD024','INV002','Import','2025-07-12 09:50:00',1450),
('PRD025','INV002','Export','2025-07-13 12:45:00',650),
('PRD026','INV003','Import','2025-07-13 07:55:00',1600),
('PRD027','INV003','Export','2025-07-14 15:15:00',800),
('PRD028','INV004','Import','2025-07-14 08:00:00',1500),
('PRD029','INV004','Export','2025-07-15 14:40:00',700),
('PRD030','INV005','Import','2025-07-15 09:00:00',1400),
('PRD031','INV005','Export','2025-07-16 16:00:00',600),
('PRD032','INV001','Import','2025-07-16 10:20:00',1200),
('PRD033','INV001','Export','2025-07-17 13:30:00',650),
('PRD034','INV002','Import','2025-07-17 08:10:00',1300),
('PRD035','INV002','Export','2025-07-18 15:25:00',550),
('PRD036','INV003','Import','2025-07-18 09:45:00',1250),
('PRD037','INV003','Export','2025-07-19 12:00:00',500),
('PRD038','INV004','Import','2025-07-19 07:30:00',1500),
('PRD039','INV004','Export','2025-07-20 11:50:00',750),
('PRD040','INV005','Import','2025-07-20 08:20:00',1450),
('PRD041','INV005','Export','2025-07-21 14:30:00',650),
('PRD042','INV001','Import','2025-07-21 10:00:00',1600),
('PRD043','INV001','Export','2025-07-22 13:10:00',700),
('PRD044','INV002','Import','2025-07-22 09:25:00',1400),
('PRD045','INV002','Export','2025-07-23 15:40:00',650),
('PRD046','INV003','Import','2025-07-23 08:00:00',1550),
('PRD047','INV003','Export','2025-07-24 14:00:00',700),
('PRD048','INV004','Import','2025-07-24 09:00:00',1300),
('PRD049','INV004','Export','2025-07-25 15:00:00',600),
('PRD050','INV005','Import','2025-07-25 08:10:00',1450);

-- --------------------------------------------------------------------------------------------------------------------------------

-- SHOW TABLES;

-- SELECT * FROM Customers;
-- SELECT * FROM Orders;
-- SELECT * FROM Products;
-- SELECT * FROM Suppliers;
-- SELECT * FROM Inventory;
-- SELECT * FROM Product_Supplier;
-- SELECT * FROM OrderDetail;
-- SELECT * FROM Ex_Im;

-- ----------------------------------------------------------------------------------------------------------------------------------
