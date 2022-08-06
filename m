Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73B9E58B59B
	for <lists+kvm@lfdr.de>; Sat,  6 Aug 2022 14:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiHFMnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Aug 2022 08:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiHFMna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Aug 2022 08:43:30 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BBA120AC
        for <kvm@vger.kernel.org>; Sat,  6 Aug 2022 05:43:29 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m2so4813526pls.4
        for <kvm@vger.kernel.org>; Sat, 06 Aug 2022 05:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc;
        bh=vvtS89Fk2u1S3Szl4rrCs3KSXNS797GmNVbZS9fGKtQ=;
        b=m8sXkde5a36qN0KoYJ2bJ2hZJZoHcsvdqHlJLJA+9UfQ6knxL03iHkL0yX/vJnkUYm
         NJ0gWx95+jm3j7nFiZ4Y0iZvW+qs4mHv8UV4mRs83140Itd/JhuCWDZrnBfKduubeAr3
         N+a0fvfQSn7mCDo3/emMPYNsjdwehzCK8DwLeQcun7cL0OevJM4ikkuyMrRFlgqfOkvD
         IajdpfYQ5PcUjLK3kN4fsM6EE431hcwnBNt6gZnyqpIqSTZczjwjBXQwBAjkrpCXK+QW
         OQeIPjlcQXtr5ZwUoxSdFFuxaPQxfcej4Qrb+MNfn6pbucxg4Vl30rzPKevnSZzolHu0
         z3Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vvtS89Fk2u1S3Szl4rrCs3KSXNS797GmNVbZS9fGKtQ=;
        b=HCaX22hoM5V0Aw3UvaaoXfIc8k0xB2jdUbUS63Xs37h5XVIS1hOyufq6yp25BAnGP+
         iOTA/Ejl3ws9cygXO5anCdj9Lehjq8gINhAxfMM8qv9Ux6lqb/Q3W1ivXVTedTXLLobE
         BNxI8PNAfHbfIVQhcNAjp0byqWO859wX7xQaPw3OJxPHUybi/oKgNhwfbw0ggoqzb+5l
         QPsZ6Jf9sViWa5lOTX9yNQV6jZFSUN+uipF9qJj7UhBSZi+7uGpJbjzhxbEPkeSJu5gE
         Ig2xgJPxQkDMeytNRRPn1T/RZBXD9T5f3DLcM5Ufz1srgXwg1OEzGpbEBFitI7Pin2+r
         Locg==
X-Gm-Message-State: ACgBeo1hUm8c9xVQxw87TZSX1aRMi8a6HjEnHfKAN6FY+47EoxihL4wz
        tS12d4Vw4k/2L3TBwzKh2uCxqZBRQUoyahrd268=
X-Google-Smtp-Source: AA6agR5Urrm4jSHRVPCUnRMY17NgBxm12XPdL2jVyvDFlrY7+PTPX/Kqs+j3KRl6ZMm+NpCkojMnglICS+PVMqaoREY=
X-Received: by 2002:a17:902:c408:b0:16d:c48d:978e with SMTP id
 k8-20020a170902c40800b0016dc48d978emr11053025plk.70.1659789809294; Sat, 06
 Aug 2022 05:43:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:6a5:b0:42:da81:5ab7 with HTTP; Sat, 6 Aug 2022
 05:43:28 -0700 (PDT)
Reply-To: cfc.ubagroup09@gmail.com
From:   Kristalina Georgieva <ubabankofafrica989@gmail.com>
Date:   Sat, 6 Aug 2022 05:43:28 -0700
Message-ID: <CAHwXt+x8qtOdkf0ZzZR_twSPtyLRJWX4MSfx5if+mLLUEVRk=Q@mail.gmail.com>
Subject: HEAD UUDISED
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,LOTTO_DEPT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Lugupeetud abisaaja!
Saatsin sulle selle kirja kuu aega tagasi, aga ma pole sinust midagi kuulnu=
d, ei
Olen kindel, et saite selle k=C3=A4tte ja sellep=C3=A4rast saatsin selle te=
ile uuesti.
Esiteks olen pr Kristalina Georgieva, tegevdirektor ja
Rahvusvahelise Valuutafondi president.

Tegelikult oleme l=C3=A4bi vaadanud k=C3=B5ik =C3=BCmbritsevad takistused j=
a probleemid
teie mittet=C3=A4ielik tehing ja teie suutmatus tasuda
=C3=BClekandetasud, mida v=C3=B5etakse teie vastu j=C3=A4rgmiste v=C3=B5ima=
luste eest
varasemate =C3=BClekannete kohta k=C3=BClastage kinnituse saamiseks meie sa=
iti 38
=C2=B0 53=E2=80=B256 =E2=80=B3 N 77 =C2=B0 2 =E2=80=B2 39 =E2=80=B3 W

Oleme direktorite n=C3=B5ukogu, Maailmapank ja Valuutafond
Washingtoni Rahvusvaheline (IMF) koos osakonnaga
Ameerika =C3=9Chendriikide riigikassa ja m=C3=B5ned teised uurimisasutused
asjakohane siin Ameerika =C3=9Chendriikides. on tellinud
meie Overseas Payment Remittance Unit, United Bank of
Africa Lome Togo, et v=C3=A4ljastada teile VISA kaart, kus $
1,5 miljonit teie fondist, et oma fondist rohkem v=C3=A4lja v=C3=B5tta.

Uurimise k=C3=A4igus avastasime koos
kardab, et teie makse on hilinenud korrumpeerunud ametnike poolt
pangast, kes =C3=BCritavad teie raha teie kontodele suunata
privaatne.

Ja t=C3=A4na anname teile teada, et teie raha on kaardile kantud
UBA panga VISA ja see on ka kohaletoimetamiseks valmis. N=C3=BC=C3=BCd
v=C3=B5tke =C3=BChendust UBA panga direktoriga, tema nimi on hr Tony
Elumelu, e-post: (cfc.ubagroup09@gmail.com)
et =C3=B6elda, kuidas ATM VISA kaarti k=C3=A4tte saada.

Lugupidamisega

Proua Kristalina Georgieva
