package com.cupidconnect.cupidconnect.models;

import jakarta.persistence.Id;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Entity // là một đối tượng trong cơ sở dữ liệu
@Table(name = "users")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "first_name", nullable = false)
    @NotNull
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Column(name = "nickname")
    private String nickname;

    @Column(name = "password", nullable = false)
    private String password;

    @ManyToOne
    @JoinColumn(name = "gender_id")
    private Gender gender; // Foreign key 'gender_id'

    @Column(name = "email", unique = true)
    private String email;

    @Column(name = "phone", unique = true)
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "dob")
    @Temporal(TemporalType.DATE) // Sử dụng TemporalType.DATE để chỉ lưu ngày tháng năm
    @JsonFormat(pattern="yyyy-MM-dd")
    private Date dob;

    @Column(name = "fb_account_id", unique = true)
    private Integer fbAccountId;

    @Column(name = "google_account_id", unique = true)
    private Integer googleAccountId;

    @Column(name = "confirmation_code")
    private String confirmationCode;

    @Column(name = "confirmation_time")
    @Temporal(TemporalType.TIMESTAMP) // Sử dụng TemporalType.TIMESTAMP để chỉ lưu ngày tháng năm và thời gian
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date confirmationTime;

    @Column(name = "popularity", precision = 5, scale = 2)
    private BigDecimal popularity;

    @Column(name = "is_active")
    private Integer isActive;

    @Column(name = "create_at")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date createAt;

    @Column(name = "update_at")
    @Temporal(TemporalType.TIMESTAMP)
    @JsonFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private Date updateAt;

    @Column(name = "is_admin") // 1: admin | 0: not admin
    private Integer isAdmin;

    @ManyToOne
    @JoinColumn(name = "role_id")
    private Role role; // Foreign key 'role_id'

    @OneToOne
    @JoinColumn(name = "profile_id", referencedColumnName = "id")
    private Profile profile; // Foreign key 'profile_id'

    
}