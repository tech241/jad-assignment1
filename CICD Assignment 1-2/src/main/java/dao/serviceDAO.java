package dao;

import models.service;
import models.serviceNavItem;
import servlets.postgresHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

public class serviceDAO {

    private static final String SQL_NAV_SERVICES =
        "SELECT cat_id, service_id, service_name " +
        "FROM service " +
        "ORDER BY cat_id, service_name";

    private static final String SQL_SERVICES_BY_CATEGORY =
        "SELECT service_id, service_name, service_description, image_path " +
        "FROM service " +
        "WHERE cat_id = ? " +
        "ORDER BY service_name";

    public Map<Integer, List<serviceNavItem>> getNavServicesByCategory() throws Exception {
        Map<Integer, List<serviceNavItem>> map = new LinkedHashMap<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(SQL_NAV_SERVICES);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int catId = rs.getInt("cat_id");
                int serviceId = rs.getInt("service_id");
                String serviceName = rs.getString("service_name");

                serviceNavItem item = new serviceNavItem(serviceId, catId, serviceName);
                map.computeIfAbsent(catId, k -> new ArrayList<>()).add(item);
            }
        }
        return map;
    }

    public List<service> getServicesByCategory(int catId) throws Exception {
        List<service> services = new ArrayList<>();

        try (Connection conn = postgresHelper.connect();
             PreparedStatement ps = conn.prepareStatement(SQL_SERVICES_BY_CATEGORY)) {

            ps.setInt(1, catId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    service s = new service();
                    s.setServiceId(rs.getInt("service_id"));
                    s.setServiceName(rs.getString("service_name"));
                    s.setServiceDescription(rs.getString("service_description"));
                    s.setImagePath(rs.getString("image_path"));
                    services.add(s);
                }
            }
        }
        return services;
    }
    private static final String SQL_SERVICE_BY_ID =
    	    "SELECT service_id, cat_id, service_name, service_description, image_path, whats_included " +
    	    "FROM service WHERE service_id = ?";

    	public service getServiceById(int serviceId) throws Exception {
    	    try (Connection conn = postgresHelper.connect();
    	         PreparedStatement ps = conn.prepareStatement(SQL_SERVICE_BY_ID)) {

    	        ps.setInt(1, serviceId);

    	        try (ResultSet rs = ps.executeQuery()) {
    	            if (rs.next()) {
    	                service s = new service();
    	                s.setServiceId(rs.getInt("service_id"));
    	                // if you have this field in your model:
    	                // s.setCatId(rs.getInt("cat_id"));
    	                s.setServiceName(rs.getString("service_name"));
    	                s.setServiceDescription(rs.getString("service_description"));
    	                s.setImagePath(rs.getString("image_path"));
    	                s.setWhatsIncluded(rs.getString("whats_included"));
    	                return s;
    	            }
    	        }
    	    }
    	    return null;
    	}

}
