package models;

public class CaretakerOption {
    private int caretakerId;
    private String name;
    private int experienceYears;
    private double rating;

    public int getCaretakerId() { return caretakerId; }
    public void setCaretakerId(int caretakerId) { this.caretakerId = caretakerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
}
