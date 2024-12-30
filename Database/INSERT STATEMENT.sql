INSERT INTO [TREATMENT] (name, session, price, image) VALUES (N'Khám Tổng Quát', 3, 1000000, null);

INSERT INTO [CHECKUP] (name, phone, date, startTime, endTime, room, status, doctorId, treatmentId)
VALUES (N'Lê Thị Hoàng Ngân', '0905614782', '2024-12-06', '10:00:00', '11:00:00', '103', 'Hoàn Thành', 23, 4)

INSERT INTO [TREATMENT_DETAIL] (details, treatmentId) 
VALUES
(N'Dịch vụ Khám Tổng Quát là một quy trình kiểm tra sức khỏe toàn diện nhằm đánh giá tình trạng sức khỏe hiện 
tại và phát hiện sớm các bệnh lý tiềm ẩn. Khách hàng sẽ được thăm khám bởi đội ngũ y bác sĩ chuyên môn, 
thực hiện các xét nghiệm cơ bản như kiểm tra huyết áp, đo đường huyết, xét nghiệm máu, nước tiểu và các 
chỉ số sinh hóa khác. Bên cạnh đó, dịch vụ còn bao gồm siêu âm, chụp X-quang, và kiểm tra các cơ quan 
quan trọng như tim, phổi, gan, thận. Kết quả khám sẽ được phân tích chi tiết và bác sĩ tư vấn cách 
điều chỉnh lối sống, chế độ ăn uống và biện pháp phòng ngừa bệnh tật, giúp khách hàng duy trì sức khỏe tốt nhất.',
1);

INSERT INTO [ROLE] (roleType) VALUES (N'Nhân Viên');

INSERT INTO [MEDICINE_STORAGE] (name, available, total, expiredDate) VALUES (N'Thuốc Ngủ', 30, 100, '2024-10-14');

INSERT INTO [EQUIPMENT] (name, status, cleaningTime, maintenance) 
VALUES (N'Cân Điện Tử', N'Có Thể Dùng', '2024-09-02', N'2 Năm');

INSERT INTO [EXAMINITION_APPOINTMENT] (name, phone, email, date, doctorId,  treatmentId) 
VALUES (N'Nguyễn Mỹ Linh', '0912467468', 'mylinh@gmail.com','2024-10-10', 11, 1);

INSERT INTO [MEDICAL_RECORD] (description, recordDate, customerId)
VALUES (N'Bệnh nhân cần nghỉ ngơi lâu dài', '2024-10-10', 6);

INSERT INTO [USER] (name, age, address, phone, email, username, password, roleId)
VALUES 
(N'NguyễN Thảo Ngọc', 
 24, 
 N'Cần Thơ', 
 '0578345256', 
 'ngocthao@gmail.com', 
 'thaongoc', 
 'ngocthao123',
 1);


 DELETE FROM EXAMINITION_APPOINTMENT WHERE id>17;

 DELETE FROM MEDICAL_RECORD_MEDICINES WHERE recordId>9;