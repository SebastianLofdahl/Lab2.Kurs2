package se.iths.sebastian.lab2.kurs2.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Anstalld {

    private final String fornamn;
    private final String efternamn;
    private final String epost;
    private final LocalDate anstallningsdatum;
    private final Avdelning avdelning;
    private Passerkort passerkort;
//    null om anställd saknar kort

    private final List<Kompetens> kompetenser = new ArrayList<>();

    public Anstalld(String fornamn, String efternamn, String epost,
                    LocalDate anstallningsdatum, Avdelning avdelning) {
        this.fornamn = fornamn;
        this.efternamn = efternamn;
        this.epost = epost;
        this.anstallningsdatum = anstallningsdatum;
        this.avdelning = avdelning;
    }

    public void setPasserkort(Passerkort passerkort) {
        this.passerkort = passerkort;
    }

    public void laggTillKompetens(Kompetens kompetens) {
        if (!kompetenser.contains(kompetens)) {
            kompetenser.add(kompetens);
        }
    }

    public List<Kompetens> getKompetenser() {
        return kompetenser;
    }

    public String getNamn() {
        return fornamn + " " + efternamn;
    }

    //Fick hjälp med denna toString, tog ett tag att lista ut detta.
    @Override
    public String toString() {
        String kort = (passerkort == null) ? "saknas" : passerkort.toString();

        String kompetensText;
        if (kompetenser.isEmpty()) {
            kompetensText = "inga registrerade";
        } else {
            List<String> namn = new ArrayList<>();
            for (Kompetens k : kompetenser) {
                namn.add(k.getNamn());
            }
            kompetensText = String.join(", ", namn);
        }

        return getNamn() + " (" + epost + "), anställd " + anstallningsdatum
                + "\n  Avdelning: " + avdelning
                + "\n  Passerkort: " + kort
                + "\n  Kompetenser: " + kompetensText;
    }
}