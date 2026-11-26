package se.iths.sebastian.lab2.kurs2.model;

public class Avdelning {

    private final String namn;
    private final String kontorsort;

    public Avdelning(String namn, String kontorsort) {
        this.namn = namn;
        this.kontorsort = kontorsort;
    }

    public String getNamn() {
        return namn;
    }

    @Override
    public String toString() {
        return namn + " (" + kontorsort + ")";
    }
}