package se.iths.sebastian.lab2.kurs2.model;

import java.time.LocalDate;

public class Passerkort {

    private final String kortnummer;
    private final LocalDate utfardandedatum;
    private final LocalDate giltigtTill;

    public Passerkort(String kortnummer, LocalDate utfardandedatum, LocalDate giltigtTill) {
        this.kortnummer = kortnummer;
        this.utfardandedatum = utfardandedatum;
        this.giltigtTill = giltigtTill;
    }

    public String getKortnummer() {
        return kortnummer;
    }

    @Override
    public String toString() {
        return kortnummer + " (utfärdat " + utfardandedatum + ", giltigt till " + giltigtTill + ")";
    }
}