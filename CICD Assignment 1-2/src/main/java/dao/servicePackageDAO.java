package dao;

import models.servicePackage;
import servlets.postgresHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class servicePackageDAO {

    private static final String SQL_BY_SERVICE =
        "SELECT package_id, service_id, package_name, package_description, price " +
        "FROM service_package WHERE service_id = ? ORDER BY price ASC";

    public List<servicePackage> getPackagesByServiceId(int serviceId) throws Exception {
        List<servicePackage> packages = new ArrayList<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(SQL_BY_SERVICE)) {

            ps.setInt(1, serviceId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    servicePackage p = new servicePackage();
                    p.setPackageId(rs.getInt("package_id"));
                    p.setServiceId(rs.getInt("service_id"));
                    p.setPackageName(rs.getString("package_name"));
                    p.setPackageDescription(rs.getString("package_description"));
                    p.setPrice(rs.getDouble("price"));
                    packages.add(p);
                }
            }
        }
        return packages;
    }
    public servicePackage getPackageSummary(int packageId) throws Exception {
        String sql =
            "SELECT p.package_id, p.service_id, p.package_name, p.package_description, p.price, s.service_name " +
            "FROM service_package p " +
            "INNER JOIN service s ON p.service_id = s.service_id " +
            "WHERE p.package_id = ?";

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, packageId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    servicePackage p = new servicePackage();
                    p.setPackageId(rs.getInt("package_id"));
                    p.setServiceId(rs.getInt("service_id"));
                    p.setPackageName(rs.getString("package_name"));
                    p.setPackageDescription(rs.getString("package_description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setServiceName(rs.getString("service_name"));
                    return p;
                }
            }
        }
        return null;
    }
}
