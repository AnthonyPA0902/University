import React, { useState, useEffect } from 'react';
import '../../admin_assets/css/schedule.css';
import TreatmentModal from '../../components/TreatmentModal';
import Swal from 'sweetalert2';

// Treatment Component
const Treatment = () => {
    const [treatment, setTreatment] = useState([]);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [editingTreatment, setEditingTreatment] = useState(null);

    useEffect(() => {
        fetch("https://localhost:7157/api/admin/treatment")
            .then((response) => response.json())
            .then((data) => {
                console.log(data)
                if (Array.isArray(data.treatments)) {
                    setTreatment(data.treatments);
                } else {
                    setTreatment([]);
                }
            })
            .catch((error) => console.error("Error fetching treatments:", error));
    }, []);

    const handleAddTreatment = (treatmentData) => {
        console.log("Submitting treatment data:", treatmentData);

        const formData = new FormData();
        formData.append("name", treatmentData.name);
        formData.append("session", treatmentData.session);
        formData.append("price", treatmentData.price);
        if (treatmentData.image) {
            formData.append("image", treatmentData.image); // Add the image file to FormData
        }

        const url = editingTreatment
            ? `https://localhost:7157/api/admin/treatment/${editingTreatment.id}`
            : "https://localhost:7157/api/admin/treatment";

        const method = editingTreatment ? "PUT" : "POST";

        fetch(url, {
            method: method,
            body: formData,
        })
            .then((response) => response.json())
            .then(() => refetchTreatmentData())
            .catch((error) => console.error("Error updating treatment:", error));

        setIsModalOpen(false);
    };


    const refetchTreatmentData = () => {
        fetch("https://localhost:7157/api/admin/treatment")
            .then((response) => response.json())
            .then((updatedData) => {
                if (Array.isArray(updatedData.treatments)) {
                    setTreatment(updatedData.treatments);
                }
            })
            .catch((error) => console.error("Error fetching updated treatment:", error));
    };

    const handleCreateClick = () => {
        setEditingTreatment(null);
        setIsModalOpen(true);
    };

    const handleEditClick = (id) => {
        fetch(`https://localhost:7157/api/admin/treatment/${id}`)
            .then((response) => response.json())
            .then((data) => {
                setEditingTreatment(data.treatment);
                setIsModalOpen(true);
            })
            .catch((error) => console.error("Error fetching treatment:", error));
    };

    const handleDeleteClick = (treatmentId) => {
        Swal.fire({
            title: 'Are you sure?',
            text: "Do you really want to delete this treatment?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
            confirmButtonText: 'Delete',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch(`https://localhost:7157/api/admin/treatment/${treatmentId}`, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                    .then((response) => response.json())
                    .then((data) => {
                        if (data.success) {
                            Swal.fire(
                                'Deleted!',
                                'Treatment has been deleted.',
                                'success'
                            );
                            refetchTreatmentData();
                        }
                    })
                    .catch((error) => {
                        Swal.fire(
                            'Error!',
                            'There was a problem deleting the treatment.',
                            'error'
                        );
                        console.error('Error deleting treatment:', error);
                    });
            }
        });
    };


    return (
        <div className="content">
            <div className="treatment-container">
                <h1>Danh sách liệu trình</h1>
                <button className="register-button" onClick={() => handleCreateClick()}>
                    Thêm liệu trình mới
                </button>
                <br />
                <br />
                <input type="text" placeholder="Tìm kiếm theo tên liệu trình" className="search-bar" />
                <table className="treatment-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên Liệu Trình</th>
                            <th>Số Buổi</th>
                            <th>Giá Tiền</th>
                            <th>Hình Ảnh</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {Array.isArray(treatment) && treatment.map((treatment, index) => (
                            <tr key={index}>
                                <td>{index + 1}</td>
                                <td>{treatment.name}</td>
                                <td>{treatment.session}</td>
                                <td>{treatment.price}</td>
                                <td style={{ textAlign: 'center', verticalAlign: 'middle' }}>
                                    {treatment.image && (
                                        <img
                                            src={`data:image/jpeg;base64,${treatment.image}`}
                                            alt="Treatment"
                                            style={{ width: "50%", height: "100px" }}
                                        />
                                    )}
                                </td>
                                <td style={{ textAlign: 'center' }}><button onClick={() => handleEditClick(treatment.id)}><img className="icon" src="/admin_assets/img/icon/edit-icon.png" alt="edit-icon" /></button>&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;<button onClick={() => handleDeleteClick(treatment.id)}><img className="icon" src="/admin_assets/img/icon/delete-icon.png" alt="edit-icon" /></button></td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                <TreatmentModal
                    isOpen={isModalOpen}
                    onClose={() => setIsModalOpen(false)}
                    onSubmit={handleAddTreatment}
                    editingTreatment={editingTreatment}
                />
            </div>
        </div>
    );
};

export default Treatment;
