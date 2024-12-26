-- Insert initial accommodations data
insert into accommodations (title, location, price, rating, reviews, image_url, type, beds, bathrooms, superhost)
values
  ('Your Own Tent', 'The Garden', 190, 4.9, 45, 'https://storage.tally.so/46092536-82aa-4efc-a845-d84097c62a4b/photo_2023-09-07_18-55-35.jpg', 'Camping', 1, 0, false),
  ('2.2 Meter Tipi', 'The Garden', 290, 4.8, 32, 'https://storage.tally.so/3b239e63-e5d3-439b-9536-6384ceb4314c/PXL_20220718_152819137-1-.jpg', 'Tipi', 1, 0, false),
  ('Shared Dorm', 'The Garden', 270, 4.7, 89, 'https://storage.tally.so/0c9a2451-3cac-4253-be21-b76c3287598b/photo_2024-03-06_19-48-31.jpg', 'Dorm', 1, 1, false),
  ('Van Parking', 'The Garden', 190, 4.85, 27, 'https://storage.tally.so/530c1104-341b-42ec-8c10-8aaa5ad56b87/DOG_9426.jpg', 'Parking', 0, 0, false),
  ('4 Meter Bell Tent', 'The Garden', 330, 4.9, 56, 'https://storage.tally.so/f385d036-6b48-4a0b-b119-2e334c0bc1f0/photo_2023-09-07_18-55-18.jpg', 'Bell Tent', 2, 0, true),
  ('5m Bell Tent', 'The Garden', 385, 4.95, 42, 'https://storage.tally.so/eb9c15bb-7cb3-4b61-a84e-1c131c23ab38/2023-08-17_Synesthesia-Portugal-by-Alexa-Ashley-0011.jpg', 'Bell Tent', 2, 0, true),
  ('Microcabin', 'The Garden', 410, 4.92, 73, 'https://storage.tally.so/93a554e1-8d1b-4606-947a-33059b65d5b9/IMG-20230516-WA0004.jpg', 'Cabin', 2, 0, true),
  ('Writer''s Room', 'The Garden', 465, 4.97, 38, 'https://storage.tally.so/78ab26bd-f87a-4d2e-9d58-9257e275e17c/20221227_124015-1-.jpg', 'Room', 2, 1, true),
  ('Valleyview Room', 'The Garden', 515, 4.98, 64, 'https://storage.tally.so/065194a8-e63d-4328-aa76-0ebbc6cc59fe/20221227_123043-1-.jpg', 'Room', 2, 1, true),
  ('The Hearth', 'The Garden', 630, 5.0, 29, 'https://storage.tally.so/43e64ccc-a48c-44c4-890b-635d3b5d8e21/image-4-1-.jpg', 'Suite', 2, 1, true),
  ('A-Frame Pod', 'The Garden', 410, 4.9, 18, 'https://storage.tally.so/8ad5a3bd-26cb-4210-b33e-16a4e015d5f7/a-framephoto_2024-02-29_14-57-04.jpg', 'Pod', 2, 0, true);