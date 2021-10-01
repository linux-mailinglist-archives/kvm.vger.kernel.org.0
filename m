Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18A541F720
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 23:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355436AbhJAVxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 17:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhJAVxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 17:53:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA2FC061775
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 14:51:46 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x8so7134384plv.8
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 14:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Y2F9tIAyLMuMdvZ+xZbB5A4lCV2UGNUjjsvsd+NvfA8=;
        b=IqBodbAuszuKM8pQGAetZW2XgfcmkkdWtfG90hb70AyKL0ZJGvJqGFS7Rs+Sx0kHUB
         d9Y1G2aNjzxF2NdweKtzDy3IvY3DwYP5QUnQGmBk6ttwcIKk951qVjuXMQYU+Z2Wk2/w
         KPLxnLJywlX3HJVcSWO+nxbJ8JlYhcBeGBnx2wGgy7E846NMiUiO04+VqV63snN5ck0f
         yLCcEpaTMwdjZRW8MBlC2D2/LBIHoWzFYOGtWVR9snyu3WyGHX/TlsOVVG+MVhOv5rLP
         lJuqin0W3oJ4XZ/i1OHR5SkERHOxQKn8//xDQUK2f+oR1QiWSH/djYitY1a+uXIQwt7m
         7fSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Y2F9tIAyLMuMdvZ+xZbB5A4lCV2UGNUjjsvsd+NvfA8=;
        b=shzlqp4VGNuYLWB4E1q2abt30gallhyX2zhRRsEoiEXww+7lk2Q4d46D9IgNA9HgG4
         CUSyaEQyzIrdSUAf32x6uE3ouDFqf2yEkz1ZMGwwYyPa69MNzoToo56fOwYocdKHp7bm
         RECeF2JZVl08hDRyA55EU+tayrOKiZ+B8EvQd10VKfrT5rt+EfmsXt3gA4hNJooZFU1v
         l7j8qnwzFVEcxtflZ/IPd+oINeZX5RbJY1Givd7K9o2VmbROXQ2rULXDmHMocS84P0Pz
         E4dOj0Ce7ab4qnJgdXy4S61cb8jApm3NF+Zjyj3DoVebeTbz/zEObu42Bfxz/LbVoqo+
         VZGQ==
X-Gm-Message-State: AOAM532F3IofAn1t2t08eY8QN0XQuLdbuu2meJ7BM6d1qky4LUChujN5
        Qc13bTStlN01ajCqdtpmCGJjqSv06ASh8ufyK5M=
X-Google-Smtp-Source: ABdhPJxC+yqB+VhxdqIkc4kyi0lRinj3bC6agkHb9rhbIB5uPW/ulqsqhziWnxV741GZ5mXpft6L765ZbP3mM9AtPqw=
X-Received: by 2002:a17:90a:854b:: with SMTP id a11mr22670686pjw.4.1633125106233;
 Fri, 01 Oct 2021 14:51:46 -0700 (PDT)
MIME-Version: 1.0
Sender: manuellawarlordibrahim7@gmail.com
Received: by 2002:a05:6a10:1d8f:0:0:0:0 with HTTP; Fri, 1 Oct 2021 14:51:45
 -0700 (PDT)
From:   manuella warlord ibrahim <manuellawarlordibrahim@gmail.com>
Date:   Fri, 1 Oct 2021 14:51:45 -0700
X-Google-Sender-Auth: LOvFaLwJ2Es9vdnyjS1uIl7wzk4
Message-ID: <CA+ZVOZjYAhK2L3_4OTskUqKMQPemnDqnbXXWmNuC7goY5z1ALg@mail.gmail.com>
Subject: =?UTF-8?Q?aspetter=C3=B2_di_leggerti=21=21=21?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Carissimo,

So che questa e-mail ti sorprender=C3=A0 poich=C3=A9 non ci siamo conosciut=
i o
incontrati prima di considerare il fatto che ho trovato il tuo
contatto e-mail tramite Internet alla ricerca di una persona di
fiducia che possa aiutarmi.

Sono la signorina Manuella Warlord Ibrahim Coulibaly, una donna di 24
anni della Repubblica della Costa d'Avorio, Africa occidentale, figlia
del defunto capo Sgt. Warlord Ibrahim Coulibaly (alias Generale IB).
Il mio defunto padre era un noto capo della milizia della Costa
d'Avorio. =C3=88 morto gioved=C3=AC 28 aprile 2011 a seguito di uno scontro=
 con
le forze repubblicane della Costa d'Avorio (FRCI). Sono costretto a
contattarvi a causa dei maltrattamenti che sto ricevendo dalla mia
matrigna.

Aveva in programma di portarmi via tutti i tesori e le propriet=C3=A0 del
mio defunto padre dopo la morte inaspettata del mio amato padre. Nel
frattempo volevo viaggiare in Europa, ma lei nasconde il mio
passaporto internazionale e altri documenti preziosi. Per fortuna non
ha scoperto dove tenevo il fascicolo di mio padre che conteneva
documenti importanti. Ora mi trovo attualmente nella Missione in
Ghana.

Sto cercando relazioni a lungo termine e assistenza agli investimenti.
Mio padre di beata memoria ha depositato la somma di 27,5 milioni di
dollari in una banca ad Accra in Ghana con il mio nome come parente
pi=C3=B9 prossimo. Avevo contattato la Banca per liquidare la caparra ma il
Direttore di Filiale mi ha detto che essendo rifugiato, il mio status
secondo la legge locale non mi autorizza ad effettuare l'operazione.
Tuttavia, mi ha consigliato di fornire un fiduciario che star=C3=A0 a mio
nome. Avrei voluto informare la mia matrigna di questo deposito ma
temo che non mi offrir=C3=A0 nulla dopo lo svincolo del denaro.

Pertanto, decido di cercare il tuo aiuto per trasferire i soldi sul
tuo conto bancario mentre mi trasferir=C3=B2 nel tuo paese e mi sistemer=C3=
=B2
con te. Poich=C3=A9 hai indicato il tuo interesse ad aiutarmi, ti dar=C3=B2=
 il
numero di conto e il contatto della banca dove il mio amato padre
defunto ha depositato i soldi con il mio nome come parente pi=C3=B9
prossimo. =C3=88 mia intenzione risarcirti con il 40% del denaro totale per
la tua assistenza e il saldo sar=C3=A0 il mio investimento in qualsiasi
impresa redditizia che mi consiglierai poich=C3=A9 non hai alcuna idea
sugli investimenti esteri. Per favore, tutte le comunicazioni devono
avvenire tramite questo indirizzo e-mail per scopi riservati
(manuellawarlordibrahimw@gmail.com).

La ringrazio molto in attesa di una sua rapida risposta. Ti dar=C3=B2 i
dettagli nella mia prossima mail dopo aver ricevuto la tua mail di
accettazione per aiutarmi,

Cordiali saluti
Miss manuella signore della guerra Ibrahim Coulibaly
(manuellawarlordibrahimw@gmail.com)
