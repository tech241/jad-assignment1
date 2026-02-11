package models;

public class service {
    private int serviceId;
    private String serviceName;
    private String serviceDescription;
    private String imagePath;

    public service() {}

    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public String getServiceDescription() { return serviceDescription; }
    public void setServiceDescription(String serviceDescription) { this.serviceDescription = serviceDescription; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    
    private String whatsIncluded;

    public String getWhatsIncluded() { return whatsIncluded; }
    public void setWhatsIncluded(String whatsIncluded) { this.whatsIncluded = whatsIncluded; }

}
