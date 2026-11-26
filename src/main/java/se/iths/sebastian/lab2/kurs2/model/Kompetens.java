package se.iths.sebastian.lab2.kurs2.model;

public class Kompetens {
    
    private final String namn;
    private final String beskrivning;

    public Kompetens(String namn, String beskrivning) {
        this.namn = namn;
        this.beskrivning = beskrivning;
    }

    public String getNamn() {
        return namn;
    }

    @Override
    public String toString() {
        return namn + " - " + beskrivning;
    }
}