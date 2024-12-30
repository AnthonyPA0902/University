import React, { useState, useEffect } from 'react';
import styles from '../assets/css/profile.module.css';
import Heading from '../components/Heading';
import decodeToken from '../components/DecodeToken';
import backgroundImage from '../assets/img/profile-background.jpg';
import Swal from 'sweetalert2';

const Profile = () => {
    const [schedule, setSchedule] = useState([]);

    useEffect(() => {
        const token = sessionStorage.getItem("token");
        if (token) {
            const decodedToken = decodeToken(token);
            if (decodedToken) {
                const customerId = decodedToken.user_id;
                console.log(customerId);

                fetch(`https://localhost:7157/api/profile/${customerId}`)
                    .then((response) => response.json())
                    .then((data) => {
                        console.log(data.schedules)
                        if (Array.isArray(data.schedules)) {
                            setSchedule(data.schedules);
                        } else {
                            setSchedule([]);
                        }
                    })
                    .catch((error) => console.error("Error fetching schedulé:", error));
            }
        }
        // Check the 'payment' parameter from the URL
        const urlParams = new URLSearchParams(window.location.search);
        const paymentStatus = urlParams.get('payment'); // Get the 'payment' param

        if (paymentStatus) {
            // If payment is successful
            if (paymentStatus === 'true') {
                Swal.fire({
                    icon: 'success',
                    title: 'Payment Successful',
                    text: 'Your payment has been successfully processed.',
                    confirmButtonText: 'OK',
                    timer: 5000, 
                }).then(() => {
                    window.history.pushState({}, '', window.location.pathname);
                    window.location.reload(); // Refresh the page
                });
            }
            // If payment failed
            else if (paymentStatus === 'false') {
                Swal.fire({
                    icon: 'error',
                    title: 'Payment Unsuccessful',
                    text: 'There was an issue with processing your payment.',
                    confirmButtonText: 'OK',
                    timer: 5000, 
                }).then(() => {
                    window.history.pushState({}, '', window.location.pathname);
                    window.location.reload(); // Refresh the page
                });
            }
        }
    }, []);

    const handleSubmit = (scheduleId, price) => {
        fetch(`https://localhost:7157/api/profile/vnpay/${scheduleId}/${price}`)
            .then((response) => response.text())
            .then((paymentUrl) => {
                window.location.href = paymentUrl;
            })
            .catch((error) => {
                console.error("Error redirecting to VnPay:", error);
                Swal.fire({
                    icon: 'error',
                    title: 'Payment failed',
                    text: 'Could not proceed to payment. Please try again later.'
                });
            });
    };

    return (
        <main className={styles.main} style={{ backgroundImage: `url(${backgroundImage})`, backgroundSize: 'cover' }}>
            {/* Header Section */}
            <Heading title="HỒ SƠ KHÁCH HÀNG" />

            {/* Services Section */}
            <table className={styles.profileTable}>
                <thead>
                    <tr>
                        <th>STT Lịch Hẹn</th>
                        <th>Ngày hẹn</th>
                        <th>Bác sĩ khám</th>
                        <th>Dịch vụ khám</th>
                        <th>Số tiền</th>
                        <th>Trạng thái</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    {Array.isArray(schedule) && schedule.map((schedule, index) => (
                        <tr key={index}>
                            <td>{index + 1}</td>
                            <td>{schedule.date}</td>
                            <td>{schedule.doctorName}</td>
                            <td>{schedule.treatmentName}</td>
                            <td>{schedule.price}</td>
                            <td>{schedule.status}</td>
                            <td>
                                {schedule.status === "Chưa Thanh Toán" ? (
                                    <button
                                        className={styles.paymentButton}
                                        onClick={() => handleSubmit(schedule.id, schedule.price)} 
                                    >
                                        Thanh Toán
                                    </button>
                                ) : (
                                    ""
                                )}
                            </td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </main>
    );
};

export default Profile;