-- Sami Katwan, Nicholas Niehaus, Nickayla Virtusio

-- droppig tables each time we re-run the script

DROP TABLE vendor CASCADE CONSTRAINT PURGE;
DROP TABLE purchase_agreement CASCADE CONSTRAINT PURGE;
DROP TABLE consignment_agreement CASCADE CONSTRAINT PURGE;
DROP TABLE sales_invoice CASCADE CONSTRAINT PURGE;
DROP TABLE service_invoice CASCADE CONSTRAINT PURGE;

DROP TABLE artist CASCADE CONSTRAINT PURGE;
DROP TABLE artwork_item_sale CASCADE CONSTRAINT PURGE;
DROP TABLE artwork_item_service CASCADE CONSTRAINT PURGE;

DROP TABLE warranty CASCADE CONSTRAINTS PURGE;
DROP TABLE service CASCADE CONSTRAINTS PURGE;

DROP TABLE employee CASCADE CONSTRAINT PURGE;

DROP TABLE preference CASCADE CONSTRAINTS PURGE;
DROP TABLE customer CASCADE CONSTRAINTS PURGE;


----TASK 1**************************************





--customer table stores all the necessary customer information, primary key customer ID
CREATE TABLE customer
(customer_id            NUMBER(4),
customer_first_name     VARCHAR2(25)   NOT NULL,
customer_last_name      VARCHAR2(25)    NOT NULL,
customer_address         VARCHAR2(30)    NOT NULL,
customer_city           VARCHAR2(20)    NOT NULL,
customer_state          VARCHAR2(20)   DEFAULT 'California',
customer_zip            VARCHAR2(20)    NOT NULL,
customer_phone_num      NUMBER(10),
customer_email          VARCHAR2(30),
    CONSTRAINT cus_id_pk Primary Key (customer_id),
    CONSTRAINT cus_ph_uk UNIQUE (customer_phone_num),
    CONSTRAINT cus_em_uk UNIQUE (customer_email));


--insert statements to include data for customers 
INSERT INTO customer
VALUES (0001, 'John' , 'Johnson', '1928 Garfield St', 'San Luis Obispo', DEFAULT, 93401, 6508980123, 'john@calpoly.edu');
    
INSERT INTO customer
VALUES (0002, 'Jake' , 'Trout', '1291 Marsh St', 'San Luis Obispo', DEFAULT, 93401, 409980123, 'jake@calpoly.edu');

INSERT INTO customer
VALUES (0003, 'Jared' , 'Knock', '152 Cuesta St', 'Arroya Grande', DEFAULT, 93405, 8057864321, 'jknock@gmail.com');

INSERT INTO customer
VALUES (0004, 'James' , 'Lick', '612 California Dr', 'Pismo', DEFAULT, 93401, 8059913321, 'james@gmail.com');

INSERT INTO customer
VALUES (0005, 'Bob' , 'Smith', '324 Hathway St', 'Atascadero', DEFAULT, 93425, 805980401, 'bsmith@gmail.com');

INSERT INTO customer
VALUES (0006, 'Berry' , 'Kiser', '560 Arlington Way', 'Dallas', 'Texas', 67091, 4839898590, 'berry@yahoo.com');

INSERT INTO customer
VALUES (0007, 'Tom' , 'Riley', '890 Longview St', 'Denver', 'Colorado', 98001, 7890934013, 'tom@udenver.edu');

INSERT INTO customer
VALUES (0008, 'Ian' , 'Craig', '9089 Wood St', 'Bend', 'Oregon', 89101, 4580911234, 'Ian@aol.com');

INSERT INTO customer
VALUES (0009, 'Jeff' , 'Richardson', '1452 Bryant Dr', 'Miami', 'Florida' , 16498, 4378907238, 'JeffR@gmail.com');

INSERT INTO customer
VALUES (0010, 'Matt' , 'Gerald', '6524 Johnson St', 'Reno', 'Nevada', 787746, 8109451093, 'mattg@yahoo.com');

-- preference  >|--------|| customer
--preference table for customers refernces customers id and customer last anme
CREATE TABLE preference
(preference_id  NUMBER(4),
customer_id    NUMBER(4)   NOT NULL,
artist_name     VARCHAR2(20),
art_type    VARCHAR2(20),
art_desc VARCHAR2(100),
start_date  DATE DEFAULT SYSDATE,
end_date    DATE,
    CONSTRAINT pref_id_pk Primary Key (preference_id),
    CONSTRAINT pref_end_ck CHECK (end_date > start_date),
    CONSTRAINT pref_cusid_fk FOREIGN KEY (customer_id) REFERENCES customer(customer_id));


--inserting data into the preference table
INSERT INTO preference 
VALUES (0001, 0001,  'Van Gogh', 'Painting', 'Big Blue Painting', '04/22/2005', '12/14/2022');

INSERT INTO preference 
VALUES (0002, 0001,  'Da Vinci', 'Ceramic', 'Tiny Pot', '04/12/2004', '10/24/2006');

INSERT INTO preference 
VALUES (0003, 0001,  'Dali', 'Painting', 'Abstract Color Pencil', '07/25/2001' , '03/09/2003');

INSERT INTO preference 
VALUES (0004, 0002,  'Picaso', 'Painting', 'Abstract Color Pencil', '05/18/2000', '03/09/2022');

INSERT INTO preference 
VALUES (0005, 0002,  'Dali', 'Ceramic', 'Old Mug', '05/20/2010', '04/19/2011');



INSERT INTO preference 
VALUES (0006, 0003,  'Van Gogh', 'Ceramic', 'Brown Bowl', DEFAULT , '05/19/2022');

INSERT INTO preference 
VALUES (0007, 0004,  'Monet', 'Painting', 'Long Green Grass', '12/13/12' , '06/19/2022');

INSERT INTO preference 
VALUES (0008, 0005,  'Dali', 'Drawing', 'Shaded Pencil','11/12/1999' , '08/20/2016');


--views
CREATE OR REPLACE VIEW custvu10
AS SELECT customer_first_name, customer_last_name, customer_address, customer_city,
    customer_state, customer_zip, customer_phone_num, customer_email
FROM customer
ORDER BY customer_last_name;

CREATE OR REPLACE VIEW custpref
AS SELECT d.customer_first_name, d.customer_last_name, d.customer_phone_num, m.art_type, 
    m.artist_name, m.start_date, m.end_date
FROM customer d
JOIN preference m
ON (d.customer_phone_num = m.art_type)
WHERE art_type IS NOT NULL;

CREATE OR REPLACE VIEW custprefall
AS SELECT d.customer_first_name, d.customer_last_name, d.customer_phone_num, NVL(m.art_type, 'No Preference') art_type, 
    m.artist_name, m.start_date, m.end_date
FROM customer d
JOIN preference m
ON (d.customer_phone_num = m.art_type);




----TASK 2**************************************






CREATE TABLE employee
    (manager_id          NUMBER(4),
    employee_id        NUMBER(4),
    emp_first_name      VARCHAR2(25)    NOT NULL,
    emp_last_name       VARCHAR2(25)    NOT NULL,
    emp_address         VARCHAR2(30)    NOT NULL,
    emp_city            VARCHAR2(30)    NOT NULL,
    emp_state           CHAR(2)         DEFAULT 'CA' NOT NULL,
    emp_zip             CHAR(7)         NOT NULL,
    emp_phone           CHAR(10)        NOT NULL,
    emp_email           CHAR(30)        NOT NULL,
    emp_date_hired      DATE            NOT NULL,
    emp_title           VARCHAR2(40)    NOT NULL,
    commission_pct      NUMBER(2,2),
    sales_person        CHAR(1)         NOT NULL,
    service_person      CHAR(1)         NOT NULL,
    manager             CHAR(1)         NOT NULL,
        CONSTRAINT emp_id_pk            PRIMARY KEY (employee_id),
        CONSTRAINT emp_phone_uk         UNIQUE (emp_phone),
        CONSTRAINT emp_email_uk         UNIQUE (emp_email),
        CONSTRAINT emp_sal_ck           CHECK (sales_person IN ('Y', 'N')),
        CONSTRAINT emp_serv_ck          CHECK (sales_person IN ('Y', 'N')),
        CONSTRAINT emp_mgr_ck           CHECK (sales_person IN ('Y', 'N')),
        CONSTRAINT emp_type_ck          CHECK(
            (sales_person   = 'Y' AND
            service_person  = 'N' AND
            manager         = 'N' AND
            commission_pct BETWEEN .2 AND .3 OR
            commission_pct =  0)
            OR
            (sales_person   = 'Y' AND
            service_person  = 'N' AND
            manager         = 'Y' AND
            commission_pct BETWEEN .2 AND .3)
            OR
            (sales_person   = 'N' AND
            service_person  = 'Y' AND
            manager         = 'N' AND
            commission_pct IS NULL)
            OR
            (sales_person   = 'N' AND
            service_person  = 'Y' AND
            manager         = 'Y' AND
            commission_pct IS NULL)
            OR
            (sales_person   = 'N' AND
            service_person  = 'Y' AND
            manager         = 'Y' AND
            commission_pct IS NULL)
            OR
            (sales_person   = 'N' AND
            service_person  = 'N' AND
            manager         = 'Y' AND
            commission_pct IS NULL)
            OR
            (sales_person   = 'N' AND
            service_person  = 'N' AND
            manager         = 'N' AND
            commission_pct IS NULL)
        )
);

--Owner**************
INSERT INTO employee
VALUES(NULL, 0001,'Leonard', 'Martini', '342 Straton St', 'Cambria', 'CA',93401, 8058724720, 
'lmartini@cambriaart.com', '03/02/2000', 'Owner', NULL, 'N','N','Y');

--Misc***************

--mgr
INSERT INTO employee
VALUES(0001, 1001,'George', 'Cruise', '286 Cuesta Dr', 'Paso Robles', 'CA', 93400, 8050903205, 
'gcruise@cambriaart.com', '04/10/2008', 'CPA', NULL, 'N','N','Y');

INSERT INTO employee
VALUES(1001, 1002,'Alex', 'McManus', '1292 Abbot St', 'San Luis Obispo', 'CA',93401, 8054210945, 
'amcmanus@cambriaart.com', '09/07/2010', 'Maintenance', NULL, 'N','N','Y');

INSERT INTO employee
VALUES(1001, 1003,'Kathy', 'Smith', '1348 Longview Dr', 'San Luis Obispo', 'CA', 93405, 8058203945, 
'ksmith@cambriaart.com', '04/10/2008', 'AR/AP Clerk', NULL, 'N','N','N');




--Services************
--mgr
INSERT INTO employee
VALUES(0001, 2002,'Ellen', 'Rambleson', '2409 Bryant Ave', 'Paso Robles', 'CA',93400, 8059960231, 
'erambleson@cambriaart.com', '01/23/2010', 'Framing and Services Assistant Manager', NULL, 'N','Y','Y');

INSERT INTO employee
VALUES(2002, 2003,'Alan', 'Wood', '1789 Johnson Ave', 'Atascadero', 'CA',93401, 8058703029, 
'awood@cambriaart.com', '10/17/2013', 'Framing Tech', NULL, 'N','Y','Y');

INSERT INTO employee
VALUES(2002, 2004,'Alonzo', 'Garcia', '819 Garfield St', 'Cambria', 'CA',93401, 8056848203, 
'agarcia@cambriaart.com', '06/01/2005', 'Packing/Shipping Tech', NULL, 'N','Y','Y');

INSERT INTO employee
VALUES(2004, 2005,'Sherry', 'Sophomore', '178 Hathway St', 'San Luis Obispo', 'CA',93401, 6500392983, 
'ssophomore@cambriaart.com', '12/10/2011', 'Cal Poly Intern', NULL, 'N','Y','N');


--Sales***************

--mgr
INSERT INTO employee
VALUES(0001, 3002,'Mary', 'McMaster', '5092 Stenner St', 'Paso Robles', 'CA',93401, 8052028873, 
'mmcmaster@cambriaart.com', '11/22/2009', 'Sales Assistant Manager', 0.25, 'Y','N','Y');

INSERT INTO employee
VALUES(3002, 3003,'Allen', 'Foster', '523 Dallas Dr', 'Cambria', 'CA',93401, 8059907621, 
'afoster@cambriaart.com', '05/07/2012', 'Sales Associate', 0.22, 'Y','N','Y');

INSERT INTO employee
VALUES(3002, 3004,'Brenda', 'St.James', '808 Firestone Way', 'Paso Robles', 'CA',93402, 8057125001, 
'bstjames@cambriaart.com', '04/28/2013', 'Sales Associate', 0.24, 'Y','N','N');


--VIEWS

CREATE OR REPLACE VIEW emp_contlst (FIRST_NAME, LAST_NAME, PHONE_NUMBER, EMAIL)
AS SELECT emp_first_name, emp_last_name, emp_phone, emp_email
FROM employee
ORDER BY emp_last_name; 

CREATE OR REPLACE VIEW emp_replst (MANAGER, MANAGER_TITLE, REPORTEE, REPORTEE_TITLE)
AS SELECT reportee.emp_first_name || ' ' || reportee.emp_last_name, reportee.emp_title,
    manager.emp_first_name || ' ' || manager.emp_last_name, manager.emp_title
FROM employee manager, employee reportee
WHERE manager.manager_id = reportee.employee_id
ORDER BY manager.emp_last_name;





----TASK 3**************************************


CREATE TABLE service(
    service_id           NUMBER(4),
    service_description  VARCHAR(30)     NOT NULL,
    service_sell_price  NUMBER(6)      NOT NULL,
    service_cost        NUMBER(6)      NOT NULL,
        CONSTRAINT serv_id_pk PRIMARY KEY (service_id),
        CONSTRAINT serv_sell_ck CHECK (service_sell_price >= 0),  -- assuming you can't sell services for free
        CONSTRAINT serv_cost_ck CHECK (service_cost >= 0) --assuming all service come at a cost (labor, materials, etc) 
);


INSERT INTO service
VALUES(1001, 'Cleaning Small', 75, 25);

INSERT INTO service
VALUES(1002, 'Cleaning Large', 150, 55);

INSERT INTO service
VALUES(1003, 'Framing Small', 200, 75);

INSERT INTO service
VALUES(1004, 'Framing Large', 400, 140);

INSERT INTO service
VALUES(1005, 'Picture Mounting Small', 50, 20);

INSERT INTO service
VALUES (1006, 'Picture Mounting Large', 100, 30);

INSERT INTO service
VALUES(1007, 'Restoration Small', 300, 100);

INSERT INTO service
VALUES (1008, 'Restoration Large', 500, 200);

INSERT INTO service
VALUES(1009, 'Installation Small', 120, 80);

INSERT INTO service
VALUES (1010, 'Installation Large', 280, 120);


CREATE TABLE warranty(
    warranty_id     NUMBER(7),
    warranty_term   NUMBER(3)        NOT NULL,
    warranty_price  NUMBER(6)       NOT NULL,
        CONSTRAINT war_id_pk PRIMARY KEY (warranty_id),
        CONSTRAINT war_pc_ck CHECK (warranty_price >= 0) --assume warranty price can't be below 0
);

INSERT INTO warranty
VALUES(0000, 0, 0);

INSERT INTO warranty
VALUES(1000, 3, 150);

INSERT INTO warranty
VALUES(1001, 5, 225);

INSERT INTO warranty
VALUES(1002, 7, 300);

CREATE OR REPLACE VIEW service_list
AS SELECT service_id, service_description, TO_CHAR(service_cost, '$99,999.99') "Cost", TO_CHAR(service_sell_price, '$99,999.99') "Selling Price", 
    TO_CHAR((service_sell_price - service_cost), '$99,999.99') "Profit Margin"
FROM service
ORDER BY service_id;

CREATE OR REPLACE VIEW Service_list_pm
AS SELECT service_id, service_description, TO_CHAR(service_cost, '$99,999.99') "Cost", TO_CHAR(service_sell_price, '$99,999.99') "Selling Price", 
    TO_CHAR((service_sell_price - service_cost), '$99,999.99') "profit margin"
FROM service
ORDER BY "profit margin" DESC;

CREATE OR REPLACE VIEW warranty_list
AS SELECT warranty_id, warranty_term, TO_CHAR(warranty_price, '$99,999.99') "Warranty Base Price"
FROM warranty
ORDER BY warranty_id;




----TASK 4**************************************




-- artist table
CREATE TABLE artist(
    artist_id           NUMBER(4),
    artist_first        VARCHAR2(20)     DEFAULT 'Unknown' NOT NULL ,
    artist_last         VARCHAR2(30)     DEFAULT 'Unknown' NOT NULL,
    artist_category     VARCHAR2(15)     NOT NULL,
    artist_location     VARCHAR2(30)     DEFAULT 'Unknown' NOT NULL,
    artist_start_year   NUMBER(4)        NOT NULL,
    artist_end_year     NUMBER(4),
    artist_description  VARCHAR2(120)    NOT NULL,

    CONSTRAINT artist_id_pk   PRIMARY KEY (artist_id),
    CONSTRAINT  artist_artistcategory_ck    CHECK   (artist_category IN  ('painter', 'photographer', 'ceramicist', 'printer', 'other'))

);

--artwork sales item
CREATE TABLE artwork_item_sale(
    artwork_sale_id          NUMBER(4),
    art_category            VARCHAR2(10)    NOT NULL,
    title                   VARCHAR2(50)    DEFAULT 'Untitled' NOT NULL,
    artist_id               NUMBER(5),
    short_description       VARCHAR2(20)    NOT NULL,
    creation_date           DATE            NOT NULL,
    art_height              NUMBER(3)       NOT NULL,
    art_width               NUMBER(3)       NOT NULL,
    art_depth               NUMBER(3)       NOT NULL,
    art_material            VARCHAR2(20)    NOT NULL,
    origin_region_city      VARCHAR2(30)    DEFAULT 'Unknown' NOT NULL,
    origin_country          VARCHAR2(30)    DEFAULT 'Unknown' NOT NULL,
    long_description        VARCHAR2(120),
    how_acquired            VARCHAR2(15)    NOT NULL,
    artwork_sale_status     VARCHAR2(15)    NOT NULL,
    sug_sell_price          VARCHAR2(10),
    min_sell_price          NUMBER(10), 


    CONSTRAINT artsale_id_pk        PRIMARY KEY (artwork_sale_id),
    CONSTRAINT artsale_artist_fk    FOREIGN KEY (artist_id) REFERENCES  artist (artist_id),
    CONSTRAINT artsale_category_ck  CHECK (art_category IN ('painting', 'ceramic', 'photo', 'print', 'other')),
    CONSTRAINT artsale_acquire_ck   CHECK (how_acquired IN ('purchase', 'consignment')),
    CONSTRAINT artsale_stat_ck      CHECK (artwork_sale_status IN ('For Sale', 'Sold', 'Returned')),
    CONSTRAINT artsale_sug_ck       CHECK (sug_sell_price >= min_sell_price)

);


/*
-assumptions for artwork_item_sale: 
-art category restircted to those 5 categories
-some artwork attributes have the possibility of being unknown - used this for defaults
-attributes in the item section of the business docs are not null
*/


--artwork item sevice
CREATE TABLE artwork_item_service(
    artwork_service_id          NUMBER(4),
    title               VARCHAR2(50)    NOT NULL,
    art_category        VARCHAR2(10)    NOT NULL,
    short_description   VARCHAR2(120)   NOT NULL,

    CONSTRAINT artserv_artid_pk PRIMARY KEY (artwork_service_id),
    CONSTRAINT artserv_category_ck CHECK (art_category IN ('painting', 'ceramic', 'photo', 'print', 'other'))
);

/*
-assumptions for artwork_item_sale: 
-art category restircted to those 5 categories
-some artwork attributes have the possibility of being unknown - used this for defaults
-attributes in the item section of the business docs are not null
*/


----TASK 5**************************************


INSERT INTO artist
VALUES (0001, 'Jake', 'Smith', 'painter', 'Orange County', 1999, 2020 , 'Big Art');

INSERT INTO artist
VALUES (0002, 'John', 'James', 'painter', 'San Luis Obispo', 1990, 2020 , 'Big Art');

INSERT INTO artist
VALUES (0003, 'Angelo', 'Michael', 'other', 'San Francisco', 1985, 2020 , 'Big sculpture');

INSERT INTO artist
VALUES (0004, 'Samantha', 'Jones', 'ceramicist', 'London', 1970, 2020 , 'Ceramics');

INSERT INTO artist
VALUES (0005, 'Antonia', 'Guadelupe', 'painter', 'Sacramento', 1999, 2020 , 'Art');

INSERT INTO artist
VALUES (0006, 'Jessie', 'Dazie', 'painter', 'San Luis Obispo', 1990, 2020 , 'Big Art');

INSERT INTO artist 
VALUES(0007, 'Donkey', 'Kong', 'painter', 'Donkey Kong Country', 1921, 1988, 'Proprietor of the Big DK Banana Co.');

INSERT INTO artist 
VALUES(0008, 'David Lee', 'Roth', 'painter', 'United States', 1970, 2020, 'Singer and Front Man of Van Halen');


CREATE TABLE vendor(
    vendor_id           NUMBER(4),
    vendor_name         VARCHAR2(30)   NOT NULL,
    vendor_emp          VARCHAR2(25),
    vendor_address      VARCHAR2(50)   NOT NULL,
    vendor_city         VARCHAR2(30)    NOT NULL,
    vendor_state        CHAR(2)         DEFAULT 'CA' NOT NULL,
    vendor_zip          NUMBER(7)       NOT NULL,
    vendor_phone        NUMBER(10)      NOT NULL,
    vendor_email        VARCHAR2(30)        NOT NULL,
    
        CONSTRAINT ven_id_pk PRIMARY KEY (vendor_id)
);

INSERT INTO vendor
VALUES (0001, 'Bill Smith', 'ACME Art Co.', '1500 Lizzie St', 'Los Angeles', 'CA', 93111, 8003333333, 'bsmith@acmeart.com' );

INSERT INTO vendor
VALUES (0002, 'Harvey Willowsmith', Null, '11 Angel Ave', 'Morro Bay', 'CA', 91222, 8051111111, 'hwillow@gmail.com' );

INSERT INTO vendor
VALUES (0003, 'Diddy Kong', 'Big DK Peanut Co.', 'Big Tree', 'Eureka', 'CA', 95503, 8059687342, 'peanutmonkey@bigdk.com');


CREATE TABLE purchase_agreement(
    purchase_id         NUMBER(4),
    purchase_date       DATE            NOT NULL,
    purchase_terms      VARCHAR2(10),
    purchase_amount     NUMBER(10)      NOT NULL,
    purchase_ship_hand  NUMBER(6)       NOT NULL,
    purchase_misc       NUMBER(6)       NOT NULL,
    vendor_id           NUMBER(4), 
    employee_id         NUMBER(4), 
    artwork_sale_id     NUMBER(4),
    
        CONSTRAINT purch_id_pk      PRIMARY KEY (purchase_id),
        CONSTRAINT purch_ven_fk     FOREIGN KEY (vendor_id)     REFERENCES vendor(vendor_id),
        CONSTRAINT purch_emp_fk     FOREIGN KEY (employee_id)   REFERENCES employee(employee_id),
        CONSTRAINT purch_item_fk    FOREIGN KEY (artwork_sale_id) REFERENCES artwork_item_sale(artwork_sale_id)
);

-- Transaction Artwork Purchase 1
INSERT INTO artwork_item_sale
VALUES (0001, 'painting', 'Big Blue Piece', 0001, 'big and blue', '01/18/1992', 
20,20,1, 'Paint, Canvas', DEFAULT, DEFAULT, 'This piece of art is big and blue', 
'purchase', 'For Sale', NULL,NULL );  

INSERT INTO purchase_agreement 
VALUES (0001, '01/20/2020',Null, 1200, 200, 30,0001, 0001,0001);

UPDATE artwork_item_sale 
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0001),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0001)
WHERE artwork_sale_id = 0001;

-- Transaction Artwork Purchase 2
INSERT INTO artwork_item_sale
VALUES (0002, 'painting', 'Cal Poly', 0002, 'Vista Granda', '01/18/2020', 
20,20,1, 'Paint, Canvas', 'San Luis Obispo', 'United States', 'This piece of art is big and blue', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0002,'01/25/2019', 'Net 30', 2000, 50, 10,0001, 0001, 0002);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0002),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0002)
WHERE artwork_sale_id = 0002;


-- Transaction Artwork Purchase 3
INSERT INTO artwork_item_sale
VALUES (0003, 'other', 'Praying Angel', 0002, 'symbol of hope', '05/13/2015', 
9,6,10, 'Clay', 'San Francisco', 'United States', 'Symbol of hope for those in need.', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0003, '09/29/2018', 'NULL', 4050, 125, 25, 0002, 0001, 0003);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0003),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0003)
WHERE artwork_sale_id = 0003;

-- Transaction Artwork Purchase 4
INSERT INTO artwork_item_sale
VALUES (0004, 'painting', 'Swan Lake', 0001, 'beauty, unknown', '07/15/2018', 
10,15,1, 'Oil paint', 'Las Vegas', 'United States', 'Depicts beauty and tranquility.', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0004,'09/29/2020', 'NULL', 2350, 35, 15,0003, 0001, 0004);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0004),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0004)
WHERE artwork_sale_id = 0004;

-- Transaction Artwork Purchase 5
INSERT INTO artwork_item_sale
VALUES (0005, 'painting', 'Sunshine', 0002, 'perfect day', '05/15/2015', 
5,7,1, 'Oil paint', 'Monterey Bay', 'United States', 'This sunny day with a white dog and children running across the beach shoreline.', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0005,'06/22/2013', 'NULL', 1555, 55, 10,0001, 0001, 0005);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0005),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0005)
WHERE artwork_sale_id = 0005;


-- Transaction Artwork Purchase 6
INSERT INTO artwork_item_sale
VALUES (0006, 'ceramic', 'Tea for Two', 0004, 'handmade tea set', '02/15/2016', 
0.1,0.9,1, 'Clay, Kiln Used', 'London', 'United Kingdom', 'Dainty tea set for two made with love.', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0006,'01/21/2017', 'NULL', 1369, 15, 10,0003, 0001, 0006);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0006),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0006)
WHERE artwork_sale_id = 0006;


-- Transaction Artwork Purchase 7
INSERT INTO artwork_item_sale
VALUES (0007, 'painting', 'Star Dazed', 0006, 'girl vs the world', '08/28/2012', 
9,12,1, 'Arylic Paint', 'Sacramento', 'United States', 'Girl depicts her will to fight.', 
'purchase',  'For Sale', NULL ,NULL );

INSERT INTO purchase_agreement
VALUES (0007,'04/30/2015', 'NULL', 3817, 75, 20, 0002, 0001, 0007);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT purchase_amount *1.25 FROM purchase_agreement WHERE purchase_id = 0007),
min_sell_price = (SELECT purchase_amount *1.10 FROM purchase_agreement WHERE purchase_id = 0007)
WHERE artwork_sale_id = 0007;




CREATE TABLE consignment_agreement(
    consignment_id              NUMBER(4),
    consignment_date            DATE            NOT NULL,
    consignment_terms           VARCHAR2(10),
    proposed_sell_price         NUMBER(10)      NOT NULL,
    minimum_sell_price          NUMBER(10)      NOT NULL,
    consign_commission_pct      NUMBER(6,2)       NOT NULL,
    start_date                  DATE            NOT NULL,
    end_date                    DATE            NOT NULL,
    vendor_id                   NUMBER(4), 
    employee_id                 NUMBER(4), 
    artwork_sale_id             NUMBER(4),

        CONSTRAINT consign_id_pk    PRIMARY KEY (consignment_id),
        CONSTRAINT consign_ven_fk   FOREIGN KEY (vendor_id)         REFERENCES vendor(vendor_id),
        CONSTRAINT consign_emp_fk   FOREIGN KEY (employee_id)       REFERENCES employee(employee_id),
        CONSTRAINT consgin_dt_ck    CHECK (start_date < end_date),
        CONSTRAINT consign_item_fk    FOREIGN KEY (artwork_sale_id)   REFERENCES artwork_item_sale(artwork_sale_id)
);

-- Transaction Consignment 1
INSERT INTO artwork_item_sale
VALUES (1001, 'painting', 'Black Lake', 0001, 'black', '11/18/1999', 
20,25,1, 'Paint, Canvas', 'Cambria', 'USA', 'This piece of art is primarly black', 
'consignment', 'For Sale', NULL,NULL );

INSERT INTO consignment_agreement
VALUES (1001, '05/25/2020', Null, 3000, 2500, 0.3, '05/25/2012', '12/25/2015', 0002, 0001, 1001);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1001),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1001)
WHERE artwork_sale_id = 1001;


-- Transaction Consignment 2
INSERT INTO artwork_item_sale
VALUES (1002, 'painting', 'Gold Watch', 0002, 'Gold', '11/18/2000', 
30,20,2, 'Paint, Canvas', 'Santa Barbara', 'USA', 'This piece of art is primarly gold', 
'consignment', 'For Sale', NULL,NULL );

INSERT INTO consignment_agreement
VALUES (1002, '05/25/2020', Null, 3500, 3100, 0.25, '06/03/2020', '12/06/2020', 0002, 0001, 1002);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1002),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1002)
WHERE artwork_sale_id = 1002;

-- Transaction Consignment 3
INSERT INTO artwork_item_sale
VALUES (1003, 'painting', 'Monkey Business', 0007, 'Monkey Painting', '07/27/1954', 0004, 0008, 0001,
'Banana & poop', 'Guatemala City', 'Guatemala', 
'Self portrait with former CIA director Allen Dulles', 'consignment',
'For Sale', NULL, NULL);

INSERT INTO consignment_agreement
VALUES(1003, '10/10/2020', 'Must sell', 50000, 49999, 0.01, '10/11/2020', '01/03/2021', 0003, 0001, 1003);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1003),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1003) 
WHERE artwork_sale_id = 1003;

-- Transaction Consignment 4
INSERT INTO artwork_item_sale
VALUES(1004, 'ceramic', 'Le Monke', 0007, 'sculpture of monkey', '09/12/1965', 1, 4, 3,
'Banana, copper wire', DEFAULT, DEFAULT, 'self portrait sculpture of monkey.', 
'consignment', 'For Sale', NULL, NULL);

INSERT INTO consignment_agreement
VALUES(1004, '10/10/2020', NULL, 20000, 16000, 0.20, '10/16/2020', '01/20/2021', 0001, 3002, 1004);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1004),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1004) 
WHERE artwork_sale_id = 1004;

-- Transaction Consignment 5
INSERT INTO artwork_item_sale
VALUES(1005, 'painting', 'Speed Stick', 0001, 'streaks of blue', '08/08/2010', 4, 4, 1,
'Deoderant on Canvas', DEFAULT, DEFAULT, 'blue lines on white canvas', 
'consignment', 'For Sale', NULL, NULL);

INSERT INTO consignment_agreement
VALUES(1005, '11/11/2020', NULL, 2000, 1500, 0.15, '11/15/2020', '01/18/2021', 0002, 3003, 1005);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1005),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1005)
WHERE artwork_sale_id = 1005;

--Transaction Consignment 6
INSERT INTO artwork_item_sale
VALUES (1006, 'ceramic', 'Going Crazy!', 0008, 'Bag of Coke', '07/27/1984', 1, 1, 1,
'plastic bag, cocaine', 'Panama City', 'Panama', 'bag of coke belonged to rock legend David Lee Roth',
'consignment', 'For Sale', NULL, NULL);

INSERT INTO consignment_agreement
VALUES(1006, '12/12/2020', NULL, 1000, 850, 0.1, '12/15/2020', '03/23/2021', 0003, 3004, 1006);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1006),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1006) 
WHERE artwork_sale_id = 1006;

--Transaction Consignment 7
INSERT INTO artwork_item_sale
VALUES (1007, 'photo', 'Magic Train', 0006, 'photo of train', '07/27/2020', 2, 2, 0,
'photo print', 'Boston', 'United States', 'Photo of magic train going from Boston to Ireland',
'consignment', 'For Sale', NULL, NULL);

INSERT INTO consignment_agreement
VALUES(1007, '12/16/2020', NULL, 105, 85, 0.12, '12/30/2020', '02/28/2021', 0001, 3003, 1007);

UPDATE artwork_item_sale
SET sug_sell_price = (SELECT proposed_sell_price FROM consignment_agreement WHERE consignment_id = 1007),
min_sell_price = (SELECT minimum_sell_price FROM consignment_agreement WHERE consignment_id = 1007) 
WHERE artwork_sale_id = 1007;




CREATE TABLE sales_invoice(
    sales_invoice_id        NUMBER(4),
    sales_date          DATE            NOT NULL,
    sales_terms         VARCHAR2(10),
    sales_discount      NUMBER(6)       NOT NULL,  
    sales_misc_charges        NUMBER(6)       NOT NULL,
    sales_ship          NUMBER(6)       NOT NULL,
    customer_id         NUMBER(4),
    employee_id         NUMBER(4),
    manager_id          NUMBER(4), -- managerid
    artwork_sale_id     NUMBER(4),
    warranty_id         NUMBER(4),

        CONSTRAINT salesinv_id_pk      PRIMARY KEY (sales_invoice_id),
        CONSTRAINT salesinv_cus_fk     FOREIGN KEY (customer_id)            REFERENCES customer(customer_id),
        CONSTRAINT salesinv_emp_fk     FOREIGN KEY (employee_id)            REFERENCES employee(employee_id),
        CONSTRAINT salesinv_mgr_fk     FOREIGN KEY (manager_id)             REFERENCES employee(employee_id),
        CONSTRAINT salesinv_item_fk    FOREIGN KEY (artwork_sale_id)        REFERENCES artwork_item_sale(artwork_sale_id),
        CONSTRAINT salesinv_war_fk     FOREIGN KEY (warranty_id)            REFERENCES warranty(warranty_id)
);

-- Transaction Artwork Sale 1
INSERT INTO sales_invoice             
VALUES (0001, '01/23/2020', 'Cash', 
200, 50, 100, 0001, 3002,0001, 0001, 0000);

UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 0001;

-- Transaction Artwork Sale 2
INSERT INTO sales_invoice             
VALUES (0002, '04/12/2020', 'Cash', 
100, 50, 200, 0002, 3002, 0001, 0002, 1001);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 0002;



-- Transaction Artwork Sale 3
INSERT INTO sales_invoice             
VALUES (0003, '05/12/2021', 'Cash', 
100, 10, 100, 0003, 3003, 3002, 0003, 1001);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 0003;


-- Transaction Artwork Sale 4
INSERT INTO sales_invoice             
VALUES (0004, '06/02/2021', 'Cash', 
200, 20, 100, 0004, 3002, 0001, 0004, 1002);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 0004;


-- Transaction Artwork Sale 5
INSERT INTO sales_invoice             
VALUES (0005, '02/02/2021', 'Cash', 
50, 10, 200, 0001, 3003, 3002, 1001, 1000);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 1001;

-- Transaction Artwork Sale 6
INSERT INTO sales_invoice             
VALUES (0006, '03/02/2021', 'Cash', 
50, 50, 100, 0003, 3004, 3003, 1002, 0000);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 1002;

-- Transaction Artwork Sale 7
INSERT INTO sales_invoice             
VALUES (0007, '03/02/2021', 'Credit', 
50, 0, 50, 0005, 3003, 3002, 1003, 1002);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 1003;


-- Transaction Artwork Sale 8
INSERT INTO sales_invoice             
VALUES (0008, '03/02/2021', 'Credit', 
200, 20, 50, 0003, 3002, 0001, 1005, 1000);


UPDATE artwork_item_sale
SET artwork_sale_status = 'Sold'
WHERE artwork_sale_id = 1005;





CREATE TABLE service_invoice(
    service_invoice_id      NUMBER(4),
    service_date            DATE            NOT NULL,
    service_terms           VARCHAR2(10),
    service_discount        NUMBER(6)       NOT NULL,
    misc_charges            NUMBER(6)       NOT NULL,
    serv_ship_hand          NUMBER(6)       NOT NULL,
    customer_id             NUMBER(4),
    employee_id             NUMBER(4),
    artwork_service_id      NUMBER(4),
    service_id              NUMBER(4),


        CONSTRAINT serviceinv_id_pk          PRIMARY KEY (service_invoice_id),
        CONSTRAINT serviceinv_cus_fk         FOREIGN KEY (customer_id)              REFERENCES customer(customer_id),
        CONSTRAINT serviceinv_emp_fk         FOREIGN KEY (employee_id)              REFERENCES employee(employee_id),
        CONSTRAINT serviceinv_item_fk        FOREIGN KEY (artwork_service_id)       REFERENCES artwork_item_service(artwork_service_id),
        CONSTRAINT serviceinv_serv_fk       FOREIGN KEY (service_id)                REFERENCES service(service_id)
);


--TRANSACTION ARTWORK SERVICE NOT SOLD BY US 1
INSERT INTO customer
VALUES (0011, 'Garrett' , 'Hudson', '324 McCollum St', 'San Luis Obispo', DEFAULT, 93401, 9252020123, 'ghudson@calpoly.edu');


INSERT INTO artwork_item_service
VALUES (2001, 'Tiny Bowl', 'ceramic', '5 inch x 5 inch bowl');

INSERT INTO service_invoice
VALUES (2001, '02/28/2020', NULL, 
50, 10, 30, 0011,2004 ,2001, 1001);


--TRANSACTION ARTWORK SERVICE NOT SOLD BY US 2
INSERT INTO customer
VALUES (0012, 'Kyle' , 'Barry', '1222 Jerry St', 'San Luis Obispo', DEFAULT, 93401, 9752020123, 'kbarry@calpoly.edu');


INSERT INTO artwork_item_service
VALUES (2002, 'Bigger Bowl', 'ceramic', '12 inch x 12 inch bowl');

INSERT INTO service_invoice
VALUES (2002, '04/20/2020', NULL, 
100, 20, 10, 0012, 2005, 2002, 1002);

--Transaction Artwork Service Not Sold by Us 3
INSERT INTO customer
VALUES (0013, 'Bill', 'Bunting', '8574 ne 55th ave', 'Miami', 'Florida', '98022', 3982389898, 'billbunting@gmail.com');

INSERT INTO artwork_item_service
VALUES (2003, 'Birthday!', 'painting', 'painting of cake with candles');

INSERT INTO service_invoice
VALUES (2003, '03/11/2021', NULL,
10, 120, 75, 0013, 2004, 2003, 1008);






----SOLD BY US--------

--TRANSACTION ARTWORK SERVICE SOLD BY US 1
INSERT INTO artwork_item_service
VALUES (1001, (SELECT title FROM artwork_item_sale WHERE artwork_sale_id = 0001),(SELECT art_category FROM artwork_item_sale WHERE artwork_sale_id = 0001), 
(SELECT short_description FROM artwork_item_sale WHERE artwork_sale_id = 0001));


INSERT INTO service_invoice
VALUES (1001, '01/23/2020' , 'Cash', 
20, 0, 0, 0001,2003 ,1001, 1004);

--TRANSACTION ARTWORK SERVICE SOLD BY US 1
INSERT INTO artwork_item_service
VALUES (1002, (SELECT title FROM artwork_item_sale WHERE artwork_sale_id = 0002),(SELECT art_category FROM artwork_item_sale WHERE artwork_sale_id = 0002), 
(SELECT short_description FROM artwork_item_sale WHERE artwork_sale_id = 0002));

INSERT INTO service_invoice
VALUES (1002, '02/10/2020' , 'Cash', 
70, 10, 20, 0002,2003 ,1002, 1004);

--TRANSACTION ARTWORK SERVICE SOLD BY US 3
INSERT INTO artwork_item_service
VALUES (1003, (SELECT title FROM artwork_item_sale WHERE artwork_sale_id = 1003),(SELECT art_category FROM artwork_item_sale WHERE artwork_sale_id = 1003), 
(SELECT short_description FROM artwork_item_sale WHERE artwork_sale_id = 1003));

INSERT INTO service_invoice
VALUES (1003, '02/10/2021' , 'Credit', 
0, 40, 60, 0003,2004 ,1003, 1005);

-- Assumption Added Dollar Sign to Column Alias for visual clarity instead of using TO_CHAR to format
-- Artwork Sales List
CREATE OR REPLACE VIEW Artwork_Sales_List
AS SELECT s.sales_invoice_id, s.sales_date, e.emp_first_name || ' ' ||  e.emp_last_name "Employee",  m.emp_first_name || ' ' || m.emp_last_name "Manager",
    s.artwork_sale_id, a.art_category, a.title, a.sug_sell_price "Suggested Selling Price $",
    s.sales_discount "Discount $", s.sales_ship "Shipping Charges $", s.sales_misc_charges "Miscellaneous Charges $", w.warranty_price "Warranty Price $", 
    ROUND(((a.sug_sell_price - s.sales_discount) + s.sales_ship + s.sales_misc_charges),2) "Subtotal $", 
    ROUND((((a.sug_sell_price - s.sales_discount) + s.sales_ship + s.sales_misc_charges) * .0825),2) "Taxes $" , 
    ROUND((((a.sug_sell_price - s.sales_discount) + s.sales_ship + s.sales_misc_charges) * 1.0825),2) "Total Selling Price $"
FROM sales_invoice s LEFT OUTER JOIN artwork_item_sale a 
ON (a.artwork_sale_id = s.artwork_sale_id)
LEFT OUTER JOIN warranty w 
ON (w.warranty_id = s.warranty_id)
LEFT OUTER JOIN employee e
ON (s.employee_id = e.employee_id)
LEFT JOIN employee m 
ON (e.employee_id = m.employee_id)
ORDER BY s.sales_invoice_id;

-- Artwork Purchase List
CREATE OR REPLACE VIEW Artwork_Purchase_List
AS SELECT p.purchase_id, p.purchase_date, v.vendor_name "Contact Name", v.vendor_emp "Company Name", e.emp_first_name || ' ' || e.emp_last_name "Employee", 
    p.artwork_sale_id, a.art_category, a.title, p.purchase_amount "Purchase Amt $", p.purchase_ship_hand "Shipping and Handling Charges $", p.purchase_misc "Miscellaneous Charges $", 
    ROUND((p.purchase_amount + p.purchase_ship_hand + p.purchase_misc),2) "Subtotal $", 
    ROUND(((p.purchase_amount + p.purchase_ship_hand + p.purchase_misc)*.0825),2) "Taxes $",
    ROUND(((p.purchase_amount + p.purchase_ship_hand + p.purchase_misc)*1.0825),2) "Total Purchase Cost $"
FROM purchase_agreement p LEFT OUTER JOIN artwork_item_sale a 
ON (p.artwork_sale_id = a.artwork_sale_id)
LEFT OUTER JOIN vendor v 
ON (p.vendor_id = v.vendor_id)
LEFT OUTER JOIN employee e 
ON (p.employee_id = e.employee_id);

--Artwork Consignment List
CREATE OR REPLACE VIEW Artwork_Consignment_List
AS SELECT c.consignment_id, c.consignment_date, v.vendor_name "Company Name", v.vendor_emp "Contact Name",
        e.emp_first_name "Manager Consigned", c.artwork_sale_id, a.art_category, a.title, TO_CHAR(c.proposed_sell_price, '$99,999.99') "Proposed Selling Price", 
        TO_CHAR(c.minimum_sell_price, '$99,999.99') "Minimum Selling Price",
        TO_CHAR(c.consign_commission_pct, '9.99') "Consignment Percentage", c.start_date, c.end_date
FROM consignment_agreement c LEFT OUTER JOIN vendor v 
ON (c.vendor_id = v.vendor_id)
LEFT OUTER JOIN artwork_item_sale a 
ON (c.artwork_sale_id = a.artwork_sale_id)
LEFT OUTER JOIN employee e 
ON (e.employee_id = c.employee_id);

--Service Invoice List
CREATE OR REPLACE VIEW servinvlst
AS SELECT i.service_invoice_id, i.service_date, c.customer_first_name || ' ' || c.customer_last_name "Customer", i.service_terms, 
    s.service_description, s.service_sell_price, i.service_discount "Discount $", i.misc_charges "Miscellaneous Charges $", 
    ROUND(((s.service_sell_price - i.service_discount) + i.misc_charges),2) "Subtotal $", 
    ROUND((((s.service_sell_price - i.service_discount) + i.misc_charges) * 0.0825),2) "Taxes $",
    ROUND((((s.service_sell_price - i.service_discount) + i.misc_charges) * 1.0825),2) "Total Service Price $"
FROM service_invoice i 
LEFT OUTER JOIN customer c
ON (i.customer_id = c.customer_id)
LEFT OUTER JOIN service s
ON (i.service_id = s.service_id);




----TASK 6**************************************



--QUERY Customer Analysis 1****************************************************
CREATE OR REPLACE VIEW Customer_Analysis_1
AS SELECT c.customer_first_name || ' ' ||  c.customer_last_name AS "Customer", c.customer_phone_num "Phone Number", COUNT(s.customer_id) AS "Pieces of Artwork Purchased"
FROM customer c LEFT OUTER JOIN sales_invoice s 
ON (c.customer_id = s.customer_id)
GROUP BY c.customer_first_name || ' ' ||  c.customer_last_name, c.customer_phone_num
ORDER BY COUNT(s.customer_id) DESC;

--QUERY Customer Analysis 2****************************************************

CREATE OR REPLACE VIEW Customer_Analysis_2
AS SELECT c.customer_first_name || ' ' ||  c.customer_last_name AS "Customer", c.customer_phone_num AS "Phone Number"
FROM customer c RIGHT OUTER JOIN sales_invoice s 
ON (c.customer_id = s.customer_id)
RIGHT OUTER JOIN service_invoice se
ON (se.customer_id = c.customer_id)
ORDER BY c.customer_last_name;


--QUERY Customer Analysis 3****************************************************

CREATE OR REPLACE VIEW Customer_Analysis_3
AS SELECT 'Amount of customers that have purchased a 
    work of art from us but have not had a work of art serviced by us: ' || 
    (COUNT(DISTINCT s.customer_id) - COUNT(DISTINCT sv.customer_id)) AS "Purchased with Out Service"
FROM sales_invoice s LEFT OUTER JOIN service_invoice sv 
ON (s.customer_id = sv.customer_id);

--QUERY Customer Analysis 4****************************************************
CREATE OR REPLACE VIEW Customer_Analysis_4
AS SELECT DISTINCT c.customer_first_name ||' '|| c.customer_last_name "Customer Interested in Paintings", 
    c.customer_phone_num "Customer Phone Number"
FROM customer c LEFT OUTER JOIN preference p
ON (c.customer_id = p.customer_id)
WHERE  (p.end_date > SYSDATE OR p.end_date IS NULL) AND p.art_type  = 'Painting';

--QUERY Customer Analysis 5****************************************************
CREATE OR REPLACE VIEW Customer_Analysis_5
AS SELECT c.customer_first_name || ' ' ||  c.customer_last_name AS "Customer", 
    c.customer_phone_num AS "Phone Number", w.warranty_id AS "Warranty ID"
FROM customer c
LEFT OUTER JOIN sales_invoice s 
ON (c.customer_id = s.customer_id)
LEFT OUTER JOIN warranty w
ON (s.warranty_id = w.warranty_id)
WHERE w.warranty_id = 0 -- no warranty is id = 0
Order BY c.customer_last_name;


--QUERY Customer Analysis 6****************************************************
CREATE OR REPLACE VIEW Customer_Analysis_6
AS SELECT c.customer_first_name || ' ' || c.customer_last_name "Customer Name", 
    COUNT(s.customer_id) "# if of Artworks Purchased"
FROM sales_invoice s LEFT OUTER JOIN customer c 
ON (s.customer_id = c.customer_id)
GROUP BY c.customer_first_name || ' ' || c.customer_last_name
HAVING COUNT(s.customer_id) = 
        (SELECT MAX(COUNT(customer_id))
        FROM sales_invoice
        GROUP BY Customer_id);

--QUERY Customer Analysis 7****************************************************
CREATE OR REPLACE VIEW Customer_Analysis_7
AS SELECT c.customer_first_name || ' ' || c.customer_last_name "Customer Name", 
    SUM((a.sug_sell_price - s.sales_discount) - p.purchase_amount) "Amount Earned"
FROM customer c RIGHT OUTER JOIN sales_invoice s
ON (c.customer_id = s.sales_invoice_id)
RIGHT OUTER JOIN artwork_item_sale a 
ON (a.artwork_sale_id = s.artwork_sale_id)
RIGHT OUTER JOIN purchase_agreement p
ON (p.artwork_sale_id = s.artwork_sale_id)
GROUP BY c.customer_first_name || ' ' || c.customer_last_name
HAVING SUM((a.sug_sell_price - s.sales_discount) - p.purchase_amount) = 
    (SELECT MAX(SUM((a.sug_sell_price - s.sales_discount) - p.purchase_amount))
    FROM customer c RIGHT OUTER JOIN sales_invoice s
    ON (c.customer_id = s.sales_invoice_id)
    RIGHT OUTER JOIN artwork_item_sale a 
    ON (a.artwork_sale_id = s.artwork_sale_id)
    RIGHT OUTER JOIN purchase_agreement p
    ON (p.artwork_sale_id = s.artwork_sale_id)
    GROUP BY c.customer_first_name || ' ' || c.customer_last_name);



--QUERY Art Sales Analysis 1****************************************************
CREATE OR REPLACE VIEW Art_Sold
AS SELECT 'NUMBER OF ARTWORK SOLD: ' || COUNT(artwork_sale_id) AS "Artwork"
FROM artwork_item_sale
WHERE (artwork_sale_status = 'Sold');


--QUERY Art Sales Analysis 2****************************************************
CREATE OR REPLACE VIEW Artwork_Sold_By_Category
AS SELECT art_category, COUNT(artwork_sale_id) "Number of Artworks Sold"
FROM artwork_item_sale 
WHERE artwork_sale_status = 'Sold'
GROUP BY art_category;
 
--QUERY Art Sales Analysis 3****************************************************
CREATE OR REPLACE VIEW Art_Sales_Analysis_3
AS SELECT SUM(p.purchase_amount) "Total Inventory Value"
FROM purchase_agreement p JOIN artwork_item_sale a
ON (p.artwork_sale_id = a.artwork_sale_id);

--QUERY Art Sales Analysis 4****************************************************
CREATE OR REPLACE VIEW Art_Sales_Analysis_4
AS SELECT c.artwork_sale_id, a.art_category, a.title, a.artwork_sale_status, a.sug_sell_price
FROM artwork_item_sale a
LEFT OUTER JOIN consignment_agreement c
ON (a.artwork_sale_id = c.artwork_sale_id)
WHERE c.end_date > SYSDATE;

--QUERY Art Sales Analysis 5****************************************************
CREATE OR REPLACE VIEW art_sales_analysis_5
AS SELECT 'Total Made in Consignment Sales ' || SUM(c.consign_commission_pct*(a.sug_sell_price - s.sales_discount)) "Total Profit From Consignment"
FROM consignment_agreement c LEFT OUTER JOIN artwork_item_sale a 
ON (c.artwork_sale_id = a.artwork_sale_id)
LEFT OUTER JOIN sales_invoice s 
ON (a.artwork_sale_id = s.artwork_sale_id);




--QUERY Art Service Analysis 1****************************************************
CREATE OR REPLACE VIEW service30days
AS SELECT 'NUMBER OF SERVICES OFFERED IN THE LAST 30 DAYS: ' || COUNT(service_date) AS "SERVICES"
FROM service_invoice
WHERE TO_DATE(service_date) >= (SYSDATE - 30);

--QUERY Art Service Analysis 2****************************************************
CREATE OR REPLACE VIEW serviceprofit
AS SELECT 'PROFIT MADE BY CAMBRIA ART GALLERY SERVICE: ' || TO_CHAR(SUM(service_sell_price - service_cost), '$99,999.99') AS "Service"
FROM service;

--QUERY Art Service Analysis 3****************************************************
CREATE OR REPLACE VIEW profitallserv
AS SELECT service_description, SUM(service_sell_price - service_cost) AS "Sum of Profits", SUM(service_cost) AS "Sum of Costs"
FROM service
GROUP BY service_description;

--QUERY Art Service Analysis 4****************************************************
CREATE OR REPLACE VIEW art_serv_4
AS SELECT s.service_description "Highest Profiting Service", SUM(s.service_sell_price - s.service_cost - i.service_discount) "Profit From Service"
FROM service s LEFT OUTER JOIN service_invoice i
ON (s.service_id = i.service_id)
GROUP BY s.service_description
HAVING SUM(s.service_sell_price - s.service_cost) = 
    (SELECT MAX(SUM(s.service_sell_price - s.service_cost))
    FROM service s LEFT OUTER JOIN service_invoice i
    ON (s.service_id = i.service_id)
    GROUP BY s.service_description);


--QUERY Profit/Employee Analysis 1****************************************************
CREATE OR REPLACE VIEW profit_emp_analysis1
AS SELECT e.emp_first_name || ' ' || e.emp_last_name "Sales Person", COUNT(s.sales_invoice_id) "Total Sales"
FROM employee e LEFT OUTER JOIN sales_invoice s
ON (e.employee_id = s.employee_id)
WHERE e.sales_person LIKE 'Y' 
GROUP BY e.emp_first_name || ' ' || e.emp_last_name
HAVING COUNT(s.sales_invoice_id) = 
    (SELECT MAX(COUNT(sales_invoice_id))
    FROM sales_invoice
    GROUP BY employee_id);


--QUERY Profit/Employee Analysis 2****************************************************

CREATE OR REPLACE VIEW profit_emp_analysis2
AS SELECT e.emp_first_name || ' ' || e.emp_last_name "Sales Person Name", SUM(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)) "Total Commission Earned"
FROM employee e LEFT OUTER JOIN sales_invoice s
ON (e.employee_id = s.employee_id)
LEFT OUTER JOIN artwork_item_sale a 
ON (s.artwork_sale_id = a.artwork_sale_id)
LEFT OUTER JOIN purchase_agreement p 
ON (s.artwork_sale_id = p.artwork_sale_id)
WHERE sales_person LIKE 'Y'
GROUP BY e.emp_first_name || ' ' || e.emp_last_name
HAVING SUM(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)) = 
    (SELECT MAX(SUM(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)))
    FROM employee e LEFT OUTER JOIN sales_invoice s
    ON (e.employee_id = s.employee_id)
    LEFT OUTER JOIN artwork_item_sale a 
    ON (s.artwork_sale_id = a.artwork_sale_id)
    LEFT OUTER JOIN purchase_agreement p 
    ON (s.artwork_sale_id = p.artwork_sale_id)
    WHERE sales_person LIKE 'Y'
    GROUP BY e.emp_first_name || ' ' || e.emp_last_name);
--QUERY Profit/Employee Analysis 3****************************************************

CREATE OR REPLACE VIEW profit_emp_analysis3
AS SELECT e.emp_first_name || ' ' || e.emp_last_name "Sales Person Name", MAX(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)) "Highest Commission Earned"
FROM employee e LEFT OUTER JOIN sales_invoice s
ON (e.employee_id = s.employee_id)
LEFT OUTER JOIN artwork_item_sale a 
ON (s.artwork_sale_id = a.artwork_sale_id)
LEFT OUTER JOIN purchase_agreement p 
ON (s.artwork_sale_id = p.artwork_sale_id)
WHERE sales_person LIKE 'Y'
GROUP BY e.emp_first_name || ' ' || e.emp_last_name
HAVING MAX(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)) = 
    (SELECT MAX(MAX(e.commission_pct*(a.sug_sell_price-s.sales_discount-p.purchase_amount)))
    FROM employee e LEFT OUTER JOIN sales_invoice s
    ON (e.employee_id = s.employee_id)
    LEFT OUTER JOIN artwork_item_sale a 
    ON (s.artwork_sale_id = a.artwork_sale_id)
    LEFT OUTER JOIN purchase_agreement p 
    ON (s.artwork_sale_id = p.artwork_sale_id)
    WHERE sales_person LIKE 'Y'
    GROUP BY e.emp_first_name || ' ' || e.emp_last_name);
    
--EXTRA CREDIT 1****************************************************
CREATE OR REPLACE VIEW ec1
AS SELECT a.artwork_sale_id "Artwork ID", a.title "Title", ar.artist_id "Artist ID", 
ar.artist_first ||' '|| ar.artist_last "Artist"
FROM artwork_item_sale a JOIN artist ar
ON (a.artist_id = ar.artist_id)
ORDER BY ar.artist_id;

--EXTRA CREDIT 2****************************************************
CREATE OR REPLACE VIEW ec2
AS SELECT ar.artist_id "Artist ID", ar.artist_first ||' '|| ar.artist_last "Artist", 
COUNT(a.artwork_sale_id) "Number of Works of Art Sold"
FROM artwork_item_sale a JOIN artist ar
ON (a.artist_id = ar.artist_id)
GROUP BY ar.artist_id, ar.artist_first, ar.artist_last
ORDER BY ar.artist_id;

--EXTRA CREDIT 3****************************************************
CREATE OR REPLACE VIEW ec3
AS SELECT *
FROM (
SELECT ar.artist_first ||' '|| ar.artist_last "Most Profitable Artist", 
SUM((a.sug_sell_price) - (p.purchase_amount)) "Profit Amount"
FROM artwork_item_sale a JOIN artist ar
ON (a.artist_id = ar.artist_id)
JOIN purchase_agreement p
ON (a.artwork_sale_id = p.artwork_sale_id)
GROUP BY ar.artist_first, ar.artist_last
ORDER BY SUM((a.sug_sell_price) - (p.purchase_amount)) DESC)
WHERE ROWNUM=1
;