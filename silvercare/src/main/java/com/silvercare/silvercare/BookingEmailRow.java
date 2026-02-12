package com.silvercare.silvercare;

public record BookingEmailRow(
    int bookingId,
    String memberName,
    String memberEmail,
    String serviceName,
    String caretakerName,
    java.time.LocalDate scheduledDate,
    java.time.LocalTime scheduledTime,
    String notes
) {}
